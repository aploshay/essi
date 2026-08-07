namespace :essi do
  desc "ESSI-2207: import Pages Online structure"
  task import_structure: :environment do
    ImportStructureTask.new.run
  end
end

class ImportStructureTask

  LOG_PATH  = Rails.root.join('log', 'essi-2207.log')
  MANIFESTS_PATH = Rails.root.join('log', 'essi-2207.manifests.log')
  METADATA_MAPPING = YAML.load_file(Rails.root.join('log', 'essi-2207.metadata_mapping.yml'))
  STRUCTURE_MAPPING = YAML.load_file(Rails.root.join('log', 'essi-2207.structure_mapping.yml'))
  FILE_MAPPING_IN = YAML.load_file(Rails.root.join('log', 'essi-2207.file_mapping.in.yml')) # from pumpkin

  def self.logger
    @@logger ||= Logger.new(LOG_PATH)
  end

  def logger
    self.class.logger
  end

  def run
    logger.info("Starting structure import")
    structures = STRUCTURE_MAPPING
    #structures = structures[0,3] # DROP ME AFTER TESTING COMPLETE
    structures.each_with_index do |s, i|
      id_in = s[:id]
      logger.info("#{i+1}/#{structures.size}: #{id_in}")
      id_out = nil
      begin
        work = find_import_work_for_export_id(id_in, METADATA_MAPPING)
        id_out = work.id
        structure_old = s[:original]
        if structure_old.nil? || structure_old.empty?
          logger.info "No original structure for #{id_in}, skipping import"
        elsif work.logical_order.order.present?
          logger.info "Existing structure for import target #{id_out}, skipping import"
        else
          logger.info "Importing original structure from #{id_in} to import target #{id_out}"
          new_mapping = import_mapping_for_work(work)
          structure_new = map_from_pumpkin_to_essi(structure_old, FILE_MAPPING_IN, new_mapping)
          #puts structure_new.to_json
          SaveStructureJob.perform_now(work, structure_new.to_json)
          #ImportStructureJob.perform_now(work.id, structure_new.to_h.)
          work.date_modified = DateTime.now
          work.save
          logger.info("Successful import for #{id_in} to #{id_out}")
          File.write(MANIFESTS_PATH, "#{id_in}/#{id_out}\n", mode: "a")
        end
      rescue => error
        logger.error("ERROR for #{id_in}: #{error.message}")
      end
    end
  end

  # mapping: pumpkin export mapping of ids, identifiers
  def find_import_work_for_export_id(id, mapping)
    source_metadata_identifier = mapping[id]['source_metadata_identifier_tesim']&.first
    if source_metadata_identifier.present?
      logger.info "find_import_work_for_export_id: source_metadata_identifier for #{id} found: #{source_metadata_identifier}"
      import_id = ActiveFedora::Base.search_with_conditions(source_metadata_identifier_tesim: source_metadata_identifier)&.first[:id]
      if import_id.present?
        logger.info "find_import_work_for_export_id: imported work found at #{import_id}"
        work = ActiveFedora::Base.find(import_id)
        work
      else
        logger.warn "find_import_work_for_export_id: matching import work not found for #{id}, skipping"
        nil
      end
    else
      logger.error "find_import_work_for_export_id: source_metadata_identifier not found for #{id}, shouldn't happen"
      nil
    end
  end

  # run on pumpkin/squirrel
  # massages { id:, label: } hash into id => label values
  def export_mapping_from_yaml(mapping)
    output_hash = {}
    mapping.each do |map|
      output_hash[map[:id]] = map[:label]
    end
    output_hash
  end

  # FIXME: add mapping by position, for when we can't trust file labels??

  # run on essi/possum
  # doubles keys for .tif/.ptif coverage
  def import_mapping_for_work(work)
    file_sets = FileSet.search_with_conditions({is_page_of_ssi: work.id}, rows: 999_999)
    mapping = {}
    file_sets.each do |fs|
      key = fs['label_tesim'].first
      keys = [key]
      keys << key.sub('.tif', '.ptif') if key.match(/\.tif/)
      keys << key.sub('.ptif', '.tif') if key.match(/\.ptif/)
      keys.each do |k|
        mapping[k] = fs[:id]
      end
    end
    mapping
  end

  def map_from_pumpkin_to_essi(structure, pumpkin_mapping, essi_mapping)
    r1 = map_structure(structure, pumpkin_mapping)
    r2 = map_structure(r1, essi_mapping)
    r2
  end

  # pages mapping: id -> label
  # dc mapping: label -> id
  def map_structure(structure, mapping)
    output = structure.dup
    output = output.with_indifferent_access if output.is_a? Hash
    case structure
    when Array
      output = structure.map { |e| map_structure(e, mapping) }
    when Hash
      if output[:original]&.present?
        output[:original] = map_structure(output[:original], mapping)
      end
      if output[:nodes]&.present?
        output[:nodes] = map_structure(output[:nodes], mapping)
      end
      if output[:proxy]&.present?
        raise StandardError, "proxy not found for #{output[:proxy]}" unless mapping[output[:proxy]]&.present? 
        output[:proxy] = mapping[output[:proxy]]
      end
    else
      # noop
    end
    output
  end
end

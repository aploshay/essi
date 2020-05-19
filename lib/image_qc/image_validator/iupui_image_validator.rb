module ImageQC
  module ImageValidator
    class IUPUIImageValidator < CustomizableImageValidator
      DEFAULT_VALIDATIONS = { format: 'TIFF',
                              compression: [],
                              page_count: [1]
                            }
    end
  end
end

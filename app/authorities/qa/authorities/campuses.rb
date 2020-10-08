module Qa::Authorities
  class Campuses < Base

    def search(id)
      all.select { |place| place[:code].match(id.to_s) }
    end

    def find(id)
      data_for(id) || {}
    end

    def all
      data_for() || []
    end

    private
      DATA = [{ code: 'IUB', label: 'IU Bloomington', url: 'https://www.indiana.edu', img_src: 'https://www.iu.edu/images/campuses/bloomington-square.jpg', img_alt: 'The Sample Gates at IU Bloomington' },
              { code: 'IUPUI', label: 'IUPUI', url: 'https://www.iupui.edu', img_src: 'https://www.iu.edu/images/campuses/campus-iupui-1.1.jpg', img_alt: 'The Campus Center at IUPUI' },
              { code: 'IUPUC', label: 'IUPUC', url: 'https://www.iupuc.edu', img_src: 'https://www.iu.edu/images/campuses/iupuc.jpg', img_alt: 'Two people sit at a table looking at a book.' },
              { code: 'IUE', label: 'IU East', url: 'https://www.iue.edu', img_src: 'https://www.iu.edu/images/campuses/east.jpg', img_alt: 'A building with flowers in the foreground' },
              # { code: 'IUFW', label: 'IU Fort Wayne', url: 'https://www.iufw.edu', img_src: 'https://www.iu.edu/images/campuses/ipfw.jpg', img_alt: 'Students walk in front of a building.' },
              { code: 'IUK', label: 'IU Kokomo', url: 'https://www.iuk.edu', img_src: 'https://www.iu.edu/images/campuses/kokomo.jpg', img_alt: 'A building with a flowering tree in the foreground' },
              { code: 'IUN', label: 'IU Northwest', url: 'https://www.iun.edu', img_src: 'https://www.iu.edu/images/campuses/northwest.jpg', img_alt: 'A terrace with flowers, a fountain, trees, and people sitting at benches' },
              { code: 'IUSB', label: 'IU South Bend', url: 'https://www.iusb.edu', img_src: 'https://www.iu.edu/images/campuses/south-bend.jpg', img_alt: 'People sit on a lawn amid flowering trees.' },
              { code: 'IUS', label: 'IU Southeast', url: 'https://www.ius.edu', img_src: 'https://www.iu.edu/images/campuses/southeast.jpg', img_alt: 'An aerial view of IU Southeast, with buildings, trees, and a pond'}
             ].map(&:with_indifferent_access).freeze

      def data_for(id = nil)
        return DATA if id.nil?
        DATA.select { |e| e[:code] == id }.first
      end
  end
end

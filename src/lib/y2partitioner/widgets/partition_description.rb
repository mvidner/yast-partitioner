require "cwm/widget"

Yast.import "HTML"

require "y2partitioner/widgets/blk_device_attributes"

module Y2Partitioner
  # CWM widgets for partitioner
  module Widgets
    # Widget that is richtext filled with description of partition passed in constructor
    class PartitionDescription < CWM::RichText
      include Yast::I18n

      # @param partition [Y2Storage::Partition] to describe
      def initialize(partition)
        textdomain "storage"
        @partition = partition
      end

      # inits widget content
      def init
        self.value = partition_text
      end

      # @macro AW
      def help
        _("Textual description of partition data and configuratio")
      end

    private

      attr_reader :partition
      alias_method :blk_device, :partition

      include BlkDeviceAttributes

      def partition_text
        # TODO: consider using e.g. erb for this kind of output
        # TRANSLATORS: heading for section about device
        output = Yast::HTML.Heading(_("Device:"))
        output << Yast::HTML.List(device_attributes_list)
        # TRANSLATORS: heading for section about Filesystem on device
        output << Yast::HTML.Heading(_("File System:"))
        output << Yast::HTML.List(filesystem_attributes_list)
      end

      def filesystem_attributes_list
        fs_type = partition.filesystem_type
        [
          # TRANSLATORS: File system and its type as human string
          format(_("File System: %s"), fs_type ? fs_type.to_human : ""),
          # TRANSLATORS: File system and its type as human string
          format(_("Mount Point: %s"), partition.filesystem_mountpoint || ""),
          # TRANSLATORS: Label associated with file system
          format(_("Label: %s"), partition.filesystem_label || "")
        ]
      end

      def device_attributes_list
        [
          device_name,
          device_size,
          device_encrypted,
          device_udev_by_path.join(Yast::HTML.Newline),
          device_udev_by_id.join(Yast::HTML.Newline),
          # TRANSLATORS: acronym for Filesystem Identifier
          format(_("FS ID: %s"), "TODO")
        ]
      end
    end
  end
end

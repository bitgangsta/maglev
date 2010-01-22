# -*- ruby -*-
if defined? Maglev
  require 'ffi'
else
  require 'rubygems'
  require 'ffi'
end

# This is an experimental FFI wrapper for http://pyyaml.org/wiki/LibYAML
#
# == TODO
# * Get structs and proper sizes working the right way
# * auto create the Enums, in case the c-code ever changes.
module LibYaml
  class LibYaml
    extend FFI::Library
    if defined? Maglev
      ffi_lib '/Users/pmclain/external/yaml-0.1.3-64/src/.libs/libyaml-0.2.dylib'
    else
      ffi_lib '/Users/pmclain/external/yaml-0.1.3-32/src/.libs/libyaml-0.2.dylib'
    end

    attach_function :yaml_get_version, [:pointer, :pointer, :pointer], :void
    attach_function :yaml_get_version_string, [], :string
    attach_function :yaml_parser_initialize, [:pointer], :int
    attach_function :yaml_parser_set_input_string, [:pointer, :string, :int], :void
    attach_function :yaml_parser_parse, [:pointer, :pointer], :int
    attach_function :yaml_event_delete, [:pointer], :void
    attach_function :yaml_parser_delete, [:pointer], :void

    ParserEventEnum = FFI::Enum.new([:yaml_no_event,
                                     :yaml_stream_start_event,
                                     :yaml_stream_end_event,
                                     :yaml_document_start_event,
                                     :yaml_document_end_event,
                                     :yaml_alias_event,
                                     :yaml_scalar_event,
                                     :yaml_sequence_start_event,
                                     :yaml_sequence_end_event,
                                     :yaml_mapping_start_event,
                                     :yaml_mapping_end_event ],
                                    :yaml_event_type_e)

    ErrorCodes = FFI::Enum.new([:yaml_no_error,
                                :yaml_memory_error,
                                :yaml_reader_error,
                                :yaml_scanner_error,
                                :yaml_parser_error,
                                :yaml_composer_error,
                                :yaml_writer_error,
                                :yaml_emitter_error],
                               :yaml_error_type_e)

    TokenTypeEnum = FFI::Enum.new([:yaml_no_token,
                                   :yaml_stream_start_token,
                                   :yaml_stream_end_token,
                                   :yaml_version_directive_token,
                                   :yaml_tag_directive_token,
                                   :yaml_document_start_token,
                                   :yaml_document_end_token,
                                   :yaml_block_sequence_start_token,
                                   :yaml_block_mapping_start_token,
                                   :yaml_block_end_token,
                                   :yaml_flow_sequence_start_token,
                                   :yaml_flow_sequence_end_token,
                                   :yaml_flow_mapping_start_token,
                                   :yaml_flow_mapping_end_token,
                                   :yaml_block_entry_token,
                                   :yaml_flow_entry_token,
                                   :yaml_key_token,
                                   :yaml_value_token,
                                   :yaml_alias_token,
                                   :yaml_anchor_token,
                                   :yaml_tag_token,
                                   :yaml_scalar_token],
                                  :yaml_token_type_t)

    # TODO: Figure these out differently...
    # TODO: Make classes for each?  class YamlParser < FFI::Buffer
    YAML_PARSER_T_SIZE = 480 # sizeof(yaml_parser_t)
    YAML_EVENT_T_SIZE  = 104 # sizeof(yaml_event_t)

    typedef :uchar, :yaml_char_t

    class YamlVersionDirective < FFI::Struct
      layout( :major,  :int,
              :minor,  :int )
    end

    # RxINC: use :string?
    class YamlTagDirective < FFI::Struct
      layout( :handle, :pointer,   #  yaml_char_t *
              :prefix, :pointer )  #  yaml_char_t *
    end

    class YamlMark < FFI::Struct
      layout( :index,  :size_t,
              :line,   :size_t,
              :column, :size_t )
    end

    #   class YamlToken < FFI::Struct
    #     @@@
    #     struct do |s|
    #       s.name 'struct yaml_token_s'
    #       s.include '/Users/pmclain/external/yaml-0.1.3-64/include/yaml.h'
    #       s.field :type, :yaml_token_type_t
    #       s.field :data, :union  # TODO: :union isn't handled yet...

    #       # TODO: guts of the union....

    #       s.field :start_mark, :yaml_mark_t
    #       s.field :end_mark, :yaml_mark_t
    #     end
    #     @@@
    #   end

    #   class YamlEvent < FFI::Struct
    #     @@@
    #     struct do |s|
    #       s.name 'struct yaml_event_s'
    #       s.include '/Users/pmclain/external/yaml-0.1.3-64/include/yaml.h'
    #       s.field :type, :yaml_event_type_t
    #       s.field :data, :union  # TODO

    #       # TODO: guts of union

    #       s.field :start_mark, :yaml_mark_t
    #       s.field :end_mark, :yaml_mark_t
    #     end
    #     @@@
    #   end
    #   class  < FFI::Struct
    #     @@@
    #     struct do |s|
    #       s.name 'struct '
    #       s.include '/Users/pmclain/external/yaml-0.1.3-64/include/yaml.h'
    #       s.field
    #       s.field
    #       s.field
    #       s.field
    #       s.field
    #     end
    #     @@@
    #   end

  end
end

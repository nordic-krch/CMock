# ==========================================
#   CMock Project - Automatic Mock Generation for C
#   Copyright (c) 2007 Mike Karlesky, Mark VanderVoord, Greg Williams
#   [Released under MIT License. Please refer to license.txt for details]
# ==========================================

$ThisIsOnlyATest = true

require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"
require 'cmock_generator'

class MockedPluginHelper
  def initialize return_this
    @return_this = return_this
  end

  def include_files
    return @return_this
  end

  def instance_structure( name, args, rettype )
    return "  #{@return_this}_#{name}(#{args}, #{rettype})"
  end

  def mock_verify( name )
    return "  #{@return_this}_#{name}"
  end

  def mock_destroy( name, args, rettype )
    return "  #{@return_this}_#{name}(#{args}, #{rettype})"
  end

  def mock_implementation(name, args)
    return "  Mock#{name}#{@return_this}(#{args.join(", ")})"
  end
end

describe CMockGenerator, "Verify CMockGenerator Module" do

  before do
    create_mocks :config, :file_writer, :utils, :plugins
    @module_name = "PoutPoutFish"

    #no strict handling
    @config.expect :mock_prefix, "Mock"
    @config.expect :mock_suffix, ""
    @config.expect :weak_mocks, false
    @config.expect :enforce_strict_ordering, nil
    @config.expect :framework, :unity
    @config.expect :includes, ["ConfigRequiredHeader1.h","ConfigRequiredHeader2.h"]
    #@config.expect :includes_h_pre_orig_header, nil #not called because includes called
    @config.expect :includes_h_post_orig_header, nil
    @config.expect :includes_c_pre_header, nil
    @config.expect :includes_c_post_header, nil
    @config.expect :subdir, nil
    @cmock_generator = CMockGenerator.new(@config, @file_writer, @utils, @plugins)
    @cmock_generator.module_name = @module_name
    @cmock_generator.mock_name = "Mock#{@module_name}"
    @cmock_generator.clean_mock_name = "Mock#{@module_name}"

    #strict handling
    @config.expect :mock_prefix, "Mock"
    @config.expect :mock_suffix, ""
    @config.expect :weak_mocks, false
    @config.expect :enforce_strict_ordering, true
    @config.expect :framework, :unity
    @config.expect :includes, nil
    @config.expect :includes_h_pre_orig_header, nil
    @config.expect :includes_h_post_orig_header, nil
    @config.expect :includes_c_pre_header, nil
    @config.expect :includes_c_post_header, nil
    @config.expect :subdir, nil
    @cmock_generator_strict = CMockGenerator.new(@config, @file_writer, @utils, @plugins)
    @cmock_generator_strict.module_name = @module_name
    @cmock_generator_strict.mock_name = "Mock#{@module_name}"
    @cmock_generator_strict.clean_mock_name = "Mock#{@module_name}"
  end

  after do
  end

  it "create the top of a header file with optional include files from config and include file from plugin" do
    @config.expect :mock_prefix, "Mock"
    @config.expect :mock_suffix, ""
    @config.expect :weak_mocks, false
    orig_filename = "PoutPoutFish.h"
    define_name = "MOCKPOUTPOUTFISH_H"
    mock_name = "MockPoutPoutFish"
    output = []
    expected = [
      "/* AUTOGENERATED FILE. DO NOT EDIT. */\n",
      "#ifndef _#{define_name}\n",
      "#define _#{define_name}\n\n",
      "#include \"ConfigRequiredHeader1.h\"\n",
      "#include \"ConfigRequiredHeader2.h\"\n",
      "#include \"#{orig_filename}\"\n",
      "#include \"PluginRequiredHeader.h\"\n",
      "\n",
      "/* Ignore the following warnings, since we are copying code */\n",
      "#if defined(__GNUC__) && !defined(__ICC)\n",
      "#if !defined(__clang__)\n",
      "#pragma GCC diagnostic ignored \"-Wpragmas\"\n",
      "#endif\n",
      "#pragma GCC diagnostic ignored \"-Wunknown-pragmas\"\n",
      "#pragma GCC diagnostic ignored \"-Wduplicate-decl-specifier\"\n",
      "#endif\n",
      "\n",
    ]

    @config.expect :orig_header_include_fmt, "#include \"%s\""
    @plugins.expect :run, "#include \"PluginRequiredHeader.h\"\n", [:include_files]

    @cmock_generator.create_mock_header_header(output, "MockPoutPoutFish.h")

    assert_equal(expected, output)
  end

  it "handle dashes and spaces in the module name" do
    #no strict handling
    @config.expect :mock_prefix, "Mock"
    @config.expect :mock_suffix, ""
    @config.expect :weak_mocks, false
    @config.expect :enforce_strict_ordering, nil
    @config.expect :framework, :unity
    @config.expect :includes, ["ConfigRequiredHeader1.h","ConfigRequiredHeader2.h"]
    @config.expect :includes_h_post_orig_header, nil
    @config.expect :includes_c_pre_header, nil
    @config.expect :includes_c_post_header, nil
    @config.expect :subdir, nil
    @cmock_generator2 = CMockGenerator.new(@config, @file_writer, @utils, @plugins)
    @cmock_generator2.module_name = "Pout-Pout Fish"
    @cmock_generator2.mock_name = "MockPout-Pout Fish"
    @cmock_generator2.clean_mock_name = "MockPout_Pout_Fish"

    @config.expect :mock_prefix, "Mock"
    @config.expect :mock_suffix, ""
    @config.expect :weak_mocks, false
    orig_filename = "Pout-Pout Fish.h"
    define_name = "MOCKPOUT_POUT_FISH_H"
    mock_name = "MockPout_Pout_Fish"
    output = []
    expected = [
      "/* AUTOGENERATED FILE. DO NOT EDIT. */\n",
      "#ifndef _#{define_name}\n",
      "#define _#{define_name}\n\n",
      "#include \"ConfigRequiredHeader1.h\"\n",
      "#include \"ConfigRequiredHeader2.h\"\n",
      "#include \"#{orig_filename}\"\n",
      "#include \"PluginRequiredHeader.h\"\n",
      "\n",
      "/* Ignore the following warnings, since we are copying code */\n",
      "#if defined(__GNUC__) && !defined(__ICC)\n",
      "#if !defined(__clang__)\n",
      "#pragma GCC diagnostic ignored \"-Wpragmas\"\n",
      "#endif\n",
      "#pragma GCC diagnostic ignored \"-Wunknown-pragmas\"\n",
      "#pragma GCC diagnostic ignored \"-Wduplicate-decl-specifier\"\n",
      "#endif\n",
      "\n",
    ]

    @config.expect :orig_header_include_fmt, "#include \"%s\""
    @plugins.expect :run, "#include \"PluginRequiredHeader.h\"\n", [:include_files]

    @cmock_generator2.create_mock_header_header(output, "MockPout-Pout Fish.h")

    assert_equal(expected, output)
  end

  it "create the top of a header file with optional include files from config" do
    @config.expect :mock_prefix, "Mock"
    @config.expect :mock_suffix, ""
    @config.expect :weak_mocks, false
    orig_filename = "PoutPoutFish.h"
    define_name = "MOCKPOUTPOUTFISH_H"
    mock_name = "MockPoutPoutFish"
    output = []
    expected = [
      "/* AUTOGENERATED FILE. DO NOT EDIT. */\n",
      "#ifndef _#{define_name}\n",
      "#define _#{define_name}\n\n",
      "#include \"ConfigRequiredHeader1.h\"\n",
      "#include \"ConfigRequiredHeader2.h\"\n",
      "#include \"#{orig_filename}\"\n",
      "\n",
      "/* Ignore the following warnings, since we are copying code */\n",
      "#if defined(__GNUC__) && !defined(__ICC)\n",
      "#if !defined(__clang__)\n",
      "#pragma GCC diagnostic ignored \"-Wpragmas\"\n",
      "#endif\n",
      "#pragma GCC diagnostic ignored \"-Wunknown-pragmas\"\n",
      "#pragma GCC diagnostic ignored \"-Wduplicate-decl-specifier\"\n",
      "#endif\n",
      "\n",
    ]

    @config.expect :orig_header_include_fmt, "#include \"%s\""
    @plugins.expect :run,  '', [:include_files]

    @cmock_generator.create_mock_header_header(output, "MockPoutPoutFish.h")

    assert_equal(expected, output)
  end

  it "create the top of a header file with include file from plugin" do
    @config.expect :mock_prefix, "Mock"
    @config.expect :mock_suffix, ""
    @config.expect :weak_mocks, false
    orig_filename = "PoutPoutFish.h"
    define_name = "MOCKPOUTPOUTFISH_H"
    mock_name = "MockPoutPoutFish"
    output = []
    expected = [
      "/* AUTOGENERATED FILE. DO NOT EDIT. */\n",
      "#ifndef _#{define_name}\n",
      "#define _#{define_name}\n\n",
      "#include \"ConfigRequiredHeader1.h\"\n",
      "#include \"ConfigRequiredHeader2.h\"\n",
      "#include \"#{orig_filename}\"\n",
      "#include \"PluginRequiredHeader.h\"\n",
      "\n",
      "/* Ignore the following warnings, since we are copying code */\n",
      "#if defined(__GNUC__) && !defined(__ICC)\n",
      "#if !defined(__clang__)\n",
      "#pragma GCC diagnostic ignored \"-Wpragmas\"\n",
      "#endif\n",
      "#pragma GCC diagnostic ignored \"-Wunknown-pragmas\"\n",
      "#pragma GCC diagnostic ignored \"-Wduplicate-decl-specifier\"\n",
      "#endif\n",
      "\n",
    ]

    @config.expect :orig_header_include_fmt, "#include \"%s\""
    @plugins.expect :run, "#include \"PluginRequiredHeader.h\"\n", [:include_files]

    @cmock_generator.create_mock_header_header(output, "MockPoutPoutFish.h")

    assert_equal(expected, output)
  end

  it "write typedefs" do
    typedefs = [ 'typedef unsigned char U8;',
                 'typedef char S8;',
                 'typedef unsigned long U32;'
                ]
    output = []
    expected = [ "\n",
                 "typedef unsigned char U8;\n",
                 "typedef char S8;\n",
                 "typedef unsigned long U32;\n",
                 "\n\n"
               ]

    @cmock_generator.create_typedefs(output, typedefs)

    assert_equal(expected, output.flatten)
  end

  it "create the header file service call declarations" do
    mock_name = "MockPoutPoutFish"

    output = []
    expected = [ "void #{mock_name}_Init(void);\n",
                 "void #{mock_name}_Destroy(void);\n",
                 "void #{mock_name}_Verify(void);\n\n"
               ]

    @cmock_generator.create_mock_header_service_call_declarations(output)

    assert_equal(expected, output)
  end

  it "append the proper footer to the header file" do
    output = []
    expected = ["\n#endif\n"]

    @cmock_generator.create_mock_header_footer(output)

    assert_equal(expected, output)
  end

  it "create a proper heading for a source file" do
    output = []
    functions = [ { :name => "uno", :args => [ { :name => "arg1" }, { :name => "arg2" } ] },
                  { :name => "dos", :args => [ { :name => "arg3" }, { :name => "arg2" } ] },
                  { :name => "tres", :args => [] }
                ]
    expected = [ "/* AUTOGENERATED FILE. DO NOT EDIT. */\n",
                 "#include <string.h>\n",
                 "#include <stdlib.h>\n",
                 "#include <setjmp.h>\n",
                 "#include \"unity.h\"\n",
                 "#include \"cmock.h\"\n",
                 "#include \"MockPoutPoutFish.h\"\n",
                 "\n",
                 "static const char* CMockString_arg1 = \"arg1\";\n",
                 "static const char* CMockString_arg2 = \"arg2\";\n",
                 "static const char* CMockString_arg3 = \"arg3\";\n",
                 "static const char* CMockString_dos = \"dos\";\n",
                 "static const char* CMockString_tres = \"tres\";\n",
                 "static const char* CMockString_uno = \"uno\";\n",
                 "\n"
               ]

    @cmock_generator.create_source_header_section(output, "MockPoutPoutFish.c", functions)

    assert_equal(expected, output)
  end

  it "create the instance structure where it is needed when no functions" do
    output = []
    functions = []
    expected = [ "static struct MockPoutPoutFishInstance\n",
                 "{\n",
                 "  unsigned char placeHolder;\n",
                 "} Mock;\n\n"
               ].join

    @cmock_generator.create_instance_structure(output, functions)

    assert_equal(expected, output.join)
  end

  it "create the instance structure where it is needed when functions required" do
    output = []
    functions = [ { :name => "First", :args => "int Candy", :return => test_return[:int] },
                  { :name => "Second", :args => "bool Smarty", :return => test_return[:string] }
                ]
    expected = [ "typedef struct _CMOCK_First_CALL_INSTANCE\n{\n",
                 "  UNITY_LINE_TYPE LineNumber;\n",
                 "  b1  b2",
                 "\n} CMOCK_First_CALL_INSTANCE;\n\n",
                 "typedef struct _CMOCK_Second_CALL_INSTANCE\n{\n",
                 "  UNITY_LINE_TYPE LineNumber;\n",
                 "\n} CMOCK_Second_CALL_INSTANCE;\n\n",
                 "static struct MockPoutPoutFishInstance\n{\n",
                 "  d1",
                 "  CMOCK_MEM_INDEX_TYPE First_CallInstance;\n",
                 "  e1  e2  e3",
                 "  CMOCK_MEM_INDEX_TYPE Second_CallInstance;\n",
                 "} Mock;\n\n"
               ].join
    @plugins.expect :run, ["  b1","  b2"],        [:instance_typedefs, functions[0]]
    @plugins.expect :run, [],                     [:instance_typedefs, functions[1]]

    @plugins.expect :run, ["  d1"],               [:instance_structure, functions[0]]
    @plugins.expect :run, ["  e1","  e2","  e3"], [:instance_structure, functions[1]]

    @cmock_generator.create_instance_structure(output, functions)

    assert_equal(expected, output.join)
  end

  it "create extern declarations for source file" do
    output = []
    expected = [ "extern jmp_buf AbortFrame;\n",
                 "\n" ]

    @cmock_generator.create_extern_declarations(output)

    assert_equal(expected, output.flatten)
  end

  it "create extern declarations for source file when using strict ordering" do
    output = []
    expected = [ "extern jmp_buf AbortFrame;\n",
                 "extern int GlobalExpectCount;\n",
                 "extern int GlobalVerifyOrder;\n",
                 "\n" ]

    @cmock_generator_strict.create_extern_declarations(output)

    assert_equal(expected, output.flatten)
  end

  it "create mock verify functions in source file when no functions specified" do
    functions = []
    output = []
    expected = "void MockPoutPoutFish_Verify(void)\n{\n}\n\n"

    @cmock_generator.create_mock_verify_function(output, functions)

    assert_equal(expected, output.join)
  end

  it "create mock verify functions in source file when extra functions specified" do
    functions = [ { :name => "First", :args => "int Candy", :return => test_return[:int] },
                  { :name => "Second", :args => "bool Smarty", :return => test_return[:string] }
                ]
    output = []
    expected = [ "void MockPoutPoutFish_Verify(void)\n{\n",
                 "  UNITY_LINE_TYPE cmock_line = TEST_LINE_NUM;\n",
                 "  Uno_First" +
                 "  Dos_First" +
                 "  Uno_Second" +
                 "  Dos_Second",
                 "}\n\n"
               ]
    @plugins.expect :run, ["  Uno_First","  Dos_First"],   [:mock_verify, functions[0]]
    @plugins.expect :run, ["  Uno_Second","  Dos_Second"], [:mock_verify, functions[1]]

    @cmock_generator.ordered = true
    @cmock_generator.create_mock_verify_function(output, functions)

    assert_equal(expected, output.flatten)
  end

  it "create mock init functions in source file" do
    output = []
    expected = [ "void MockPoutPoutFish_Init(void)\n{\n",
                 "  MockPoutPoutFish_Destroy();\n",
                 "}\n\n"
               ]

    @cmock_generator.create_mock_init_function(output)

    assert_equal(expected.join, output.join)
  end

  it "create mock destroy functions in source file" do
    functions = []
    output = []
    expected = [ "void MockPoutPoutFish_Destroy(void)\n{\n",
                 "  CMock_Guts_MemFreeAll();\n",
                 "  memset(&Mock, 0, sizeof(Mock));\n",
                 "}\n\n"
               ]

    @cmock_generator.create_mock_destroy_function(output, functions)

    assert_equal(expected.join, output.join)
  end

  it "create mock destroy functions in source file when specified with strict ordering" do
    functions = [ { :name => "First", :args => "int Candy", :return => test_return[:int] },
                  { :name => "Second", :args => "bool Smarty", :return => test_return[:string] }
                ]
    output = []
    expected = [ "void MockPoutPoutFish_Destroy(void)\n{\n",
                 "  CMock_Guts_MemFreeAll();\n",
                 "  memset(&Mock, 0, sizeof(Mock));\n",
                 "  uno",
                 "  GlobalExpectCount = 0;\n",
                 "  GlobalVerifyOrder = 0;\n",
                 "}\n\n"
               ]
    @plugins.expect :run, [],        [:mock_destroy, functions[0]]
    @plugins.expect :run, ["  uno"], [:mock_destroy, functions[1]]

    @cmock_generator_strict.create_mock_destroy_function(output, functions)

    assert_equal(expected.join, output.join)
  end

  it "create mock implementation functions in source file" do
    function = { :modifier => "static",
                 :return => test_return[:int],
                 :args_string => "uint32 sandwiches, const char* named",
                 :args => ["uint32 sandwiches", "const char* named"],
                 :var_arg => nil,
                 :name => "SupaFunction",
                 :attributes => "__inline"
               }
    output = []
    expected = [ "static int SupaFunction(uint32 sandwiches, const char* named)\n",
                 "{\n",
                 "  UNITY_LINE_TYPE cmock_line = TEST_LINE_NUM;\n",
                 "  UNITY_SET_DETAIL(CMockString_SupaFunction);\n",
                 "  CMOCK_SupaFunction_CALL_INSTANCE* cmock_call_instance = (CMOCK_SupaFunction_CALL_INSTANCE*)CMock_Guts_GetAddressFor(Mock.SupaFunction_CallInstance);\n",
                 "  Mock.SupaFunction_CallInstance = CMock_Guts_MemNext(Mock.SupaFunction_CallInstance);\n",
                 "  uno",
                 "  UNITY_TEST_ASSERT_NOT_NULL(cmock_call_instance, cmock_line, CMockStringCalledMore);\n",
                 "  cmock_line = cmock_call_instance->LineNumber;\n",
                 "  dos",
                 "  tres",
                 "  UNITY_CLR_DETAILS();\n",
                 "  return cmock_call_instance->ReturnVal;\n",
                 "}\n\n"
               ]
    @plugins.expect :run, ["  uno"],          [:mock_implementation_precheck, function]
    @plugins.expect :run, ["  dos","  tres"], [:mock_implementation, function]

    @cmock_generator.create_mock_implementation(output, function)

    assert_equal(expected.join, output.join)
  end

  it "create mock implementation functions in source file with different options" do
    function = { :modifier => "",
                 :c_calling_convention => "__stdcall",
                 :return => test_return[:int],
                 :args_string => "uint32 sandwiches",
                 :args => ["uint32 sandwiches"],
                 :var_arg => "corn ...",
                 :name => "SupaFunction",
                 :attributes => nil
               }
    output = []
    expected = [ "int __stdcall SupaFunction(uint32 sandwiches, corn ...)\n",
                 "{\n",
                 "  UNITY_LINE_TYPE cmock_line = TEST_LINE_NUM;\n",
                 "  UNITY_SET_DETAIL(CMockString_SupaFunction);\n",
                 "  CMOCK_SupaFunction_CALL_INSTANCE* cmock_call_instance = (CMOCK_SupaFunction_CALL_INSTANCE*)CMock_Guts_GetAddressFor(Mock.SupaFunction_CallInstance);\n",
                 "  Mock.SupaFunction_CallInstance = CMock_Guts_MemNext(Mock.SupaFunction_CallInstance);\n",
                 "  uno",
                 "  UNITY_TEST_ASSERT_NOT_NULL(cmock_call_instance, cmock_line, CMockStringCalledMore);\n",
                 "  cmock_line = cmock_call_instance->LineNumber;\n",
                 "  dos",
                 "  tres",
                 "  UNITY_CLR_DETAILS();\n",
                 "  return cmock_call_instance->ReturnVal;\n",
                 "}\n\n"
               ]
    @plugins.expect :run, ["  uno"],          [:mock_implementation_precheck, function]
    @plugins.expect :run, ["  dos","  tres"], [:mock_implementation, function]

    @cmock_generator.create_mock_implementation(output, function)

    assert_equal(expected.join, output.join)
  end
end

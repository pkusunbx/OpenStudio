#ifndef MEASURE_I
#define MEASURE_I

#ifdef SWIGPYTHON
%module openstudiomeasure
#endif


#define UTILITIES_API
#define MODEL_API
#define STANDARDSINTERFACE_API
#define MEASURE_API

%include <utilities/core/CommonInclude.i>
%import <utilities/core/CommonImport.i>
%import <utilities/Utilities.i>
%import <model/Model.i>

%ignore openstudio::detail;
%ignore openstudio::model::detail;
%ignore openstudio::measure::detail;

#if defined(SWIGCSHARP)
  // Help in overload resolution preferring std::string over char const *
  %ignore openstudio::measure::OSArgument::setValue(char const*);
  %ignore openstudio::measure::OSArgument::setDefaultValue(char const*);
#endif

%{
  #include <measure/OSArgument.hpp>
  #include <measure/OSOutput.hpp>
  #include <measure/OSRunner.hpp>
  #include <measure/OSMeasure.hpp>
  #include <measure/OSMeasureInfoGetter.hpp>

  #include <measure/EnergyPlusMeasure.hpp>
  #include <measure/ModelMeasure.hpp>
  #include <measure/FMUMeasure.hpp>
  #include <measure/PythonMeasure.hpp>
  #include <measure/ReportingMeasure.hpp>

  #include <model/Component.hpp>
  #include <model/ConcreteModelObjects.hpp>

  #include <utilities/core/Path.hpp>
  #include <utilities/bcl/BCLMeasure.hpp>

  using namespace openstudio;
  using namespace openstudio::model;
  using namespace openstudio::measure;
%}

//user scripts
%template(OSArgumentVector) std::vector<openstudio::measure::OSArgument>;
%template(OptionalOSArgument) boost::optional<openstudio::measure::OSArgument>;
%template(OSArgumentMap) std::map<std::string, openstudio::measure::OSArgument>;

%ignore std::vector<openstudio::measure::OSOutput>::vector(size_type);
%ignore std::vector<openstudio::measure::OSOutput>::resize(size_type);
%template(OSOutputVector) std::vector<openstudio::measure::OSOutput>;
%template(OptionalOSOutput) boost::optional<openstudio::measure::OSOutput>;

%feature("director") OSMeasure;
%feature("director") ModelMeasure;
%feature("director") FMUMeasure;
%feature("director") PythonMeasure;
%feature("director") EnergyPlusMeasure;
%feature("director") ReportingMeasure;
%feature("director") OSRunner;

%include <measure/OSArgument.hpp>
%include <measure/OSOutput.hpp>
%include <measure/OSRunner.hpp>
%include <measure/OSMeasure.hpp>
%include <measure/ModelMeasure.hpp>
%include <measure/EnergyPlusMeasure.hpp>
%include <measure/FMUMeasure.hpp>
%include <measure/PythonMeasure.hpp>
%include <measure/ReportingMeasure.hpp>

%extend openstudio::measure::OSArgument {
  std::string __str__() {
    std::ostringstream os;
    os << *self;
    return os.str();
  }
};

%extend openstudio::measure::OSOutput {
  std::string __str__() {
    std::ostringstream os;
    os << *self;
    return os.str();
  }

  #ifdef SWIGRUBY
    // get an integral representation of the pointer that is this openstudio::measure::OSOutput
    inline long long __toInt() {
      std::clog << "original pointer: " << $self << '\n';
      const auto result = reinterpret_cast<long long>($self);
      std::clog << "toInt from C++ " << result << '\n';
      return result;
    }
  #endif

  #ifdef SWIGPYTHON
    // take the integer from toInt and reinterpret_cast it back into a openstudio::measure::OSOutput *, then return that as a reference
    static inline openstudio::measure::OSOutput& _fromInt(long long i) {
      auto *ptr = reinterpret_cast<openstudio::measure::OSOutput *>(i);
      std::clog << "Reclaimed pointer: " << ptr << '\n';
      return *ptr;
    }
  #endif

};

#if defined SWIGRUBY

  %ignore OSMeasureInfoGetter;

  %include <measure/OSMeasureInfoGetter.hpp>

  %init %{
    rb_eval_string("OpenStudio::Measure.instance_eval { def getInfo(measure,model=OpenStudio::Model::OptionalModel.new,workspace=OpenStudio::OptionalWorkspace.new) eval(OpenStudio::Measure::infoExtractorRubyFunction); return infoExtractor(measure,OpenStudio::Model::OptionalModel.new(model),OpenStudio::OptionalWorkspace.new(workspace)); end }");
  %}

#endif

#endif // MEASURE_I

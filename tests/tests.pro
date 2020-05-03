#   OpenNN: Open Neural Networks Library                                                          
#   www.opennn.net                                                                                
#                                                                                                 
#   T E S T S   P R O J E C T                                                                     
#                                                                                                 
#   Artificial Intelligence Techniques SL (Artelnics)                                             
#   artelnics@artelnics.com                                                                       

QT = # Do not use Qt

CONFIG += console
CONFIG += c++11

mac{
    CONFIG-=app_bundle
}

TARGET = opennntests

TEMPLATE = app

DESTDIR = "$$PWD/bin"

SOURCES += \
    data_set_test.cpp \
    unscaling_layer_test.cpp \
    scaling_layer_test.cpp \
    probabilistic_layer_test.cpp \
    perceptron_layer_test.cpp \
    long_short_term_memory_layer_test.cpp \
    recurrent_layer_test.cpp \
    neural_network_test.cpp \
    bounding_layer_test.cpp \
    sum_squared_error_test.cpp \
    weighted_squared_error_test.cpp \
    minkowski_error_test.cpp \
    mean_squared_error_test.cpp \
    normalized_squared_error_test.cpp \
    cross_entropy_error_test.cpp \
    training_strategy_test.cpp \
    learning_rate_algorithm_test.cpp \
    quasi_newton_method_test.cpp \
    levenberg_marquardt_algorithm_test.cpp \
    gradient_descent_test.cpp \
    conjugate_gradient_test.cpp \
    model_selection_test.cpp \
    neurons_selection_test.cpp \
    incremental_neurons_test.cpp \
    inputs_selection_test.cpp \
    growing_inputs_test.cpp \
    pruning_inputs_test.cpp \
    genetic_algorithm_test.cpp \
    testing_analysis_test.cpp \
    vector_test.cpp \
    matrix_test.cpp \
    tensor_test.cpp \
    numerical_differentiation_test.cpp \
    correlations_test.cpp \
    stochastic_gradient_descent_test.cpp \
    statistics_test.cpp \
    metrics_test.cpp \
    convolutional_layer_test.cpp \
    pooling_layer_test.cpp \
    functions_test.cpp \
    transformations_test.cpp \
    main.cpp

HEADERS += \
    unit_testing.h \
    data_set_test.h \
    unscaling_layer_test.h \
    scaling_layer_test.h \
    probabilistic_layer_test.h \
    perceptron_layer_test.h \
    long_short_term_memory_layer_test.h \
    recurrent_layer_test.h \
    neural_network_test.h \
    bounding_layer_test.h \
    sum_squared_error_test.h \
    weighted_squared_error_test.h \
    minkowski_error_test.h \
    mean_squared_error_test.h \
    normalized_squared_error_test.h \
    cross_entropy_error_test.h \
    training_strategy_test.h \
    learning_rate_algorithm_test.h \
    quasi_newton_method_test.h \
    levenberg_marquardt_algorithm_test.h \
    gradient_descent_test.h \
    conjugate_gradient_test.h \
    model_selection_test.h \
    neurons_selection_test.h \
    incremental_neurons_test.h \
    inputs_selection_test.h \
    growing_inputs_test.h \
    pruning_inputs_test.h \
    genetic_algorithm_test.h \
    testing_analysis_test.h  \
    vector_test.h \
    matrix_test.h \
    tensor_test.h \
    numerical_differentiation_test.h \
    opennn_tests.h \
    stochastic_gradient_descent_test.h \
    correlations_test.h \
    statistics_test.h \
    metrics_test.h \
    convolutional_layer_test.h \
    functions_test.h \
    transformations_test.h \
    pooling_layer_test.h

win32-g++{
QMAKE_LFLAGS += -static-libgcc
QMAKE_LFLAGS += -static-libstdc++
QMAKE_LFLAGS += -static

QMAKE_CXXFLAGS += -std=c++11 -fopenmp -pthread -lgomp
QMAKE_LFLAGS += -fopenmp -pthread -lgomp
LIBS += -fopenmp -pthread -lgomp
}

# OpenNN library

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../opennn/release/ -lopennn
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../opennn/debug/ -lopennn
else:unix: LIBS += -L$$OUT_PWD/../opennn/ -lopennn

INCLUDEPATH += $$PWD/../opennn
DEPENDPATH += $$PWD/../opennn

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../opennn/release/libopennn.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../opennn/debug/libopennn.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../opennn/release/opennn.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../opennn/debug/opennn.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../opennn/libopennn.a

# OpenMP library
win32:!win32-g++{
QMAKE_CXXFLAGS += -openmp
QMAKE_LFLAGS  += -openmp
}

unix:!macx{
QMAKE_CXXFLAGS+= -fopenmp
QMAKE_LFLAGS += -fopenmp

QMAKE_CXXFLAGS+= -std=c++11
QMAKE_LFLAGS += -std=c++11
}

mac{
#QMAKE_CXXFLAGS+= -fopenmp
#QMAKE_LFLAGS += -fopenmp

#INCLUDEPATH += /usr/local/Cellar/libiomp/20150701/include/libiomp
#LIBS += -L/usr/local/Cellar/libiomp/20150701/lib -liomp5
}

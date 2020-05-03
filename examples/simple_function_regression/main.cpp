//   OpenNN: Open Neural Networks Library
//   www.opennn.net
//
//   S I M P L E   F U N C T I O N   R E G R E S S I O N   A P P L I C A T I O N
//
//   Artificial Intelligence Techniques SL (Artelnics)
//   artelnics@artelnics.com

// This is an approximation application. 

// System includes

#include <iostream>
#include <sstream>
#include <time.h>
#include <stdexcept>

// OpenNN includes

#include "../../opennn/opennn.h"

using namespace std;
using namespace OpenNN;

int main(void)
{
    try
    {
        cout << "OpenNN. Simple Function Regression Example." << endl;

        srand(static_cast<unsigned>(time(nullptr)));

        // Data set

        DataSet data_set("D:/Artelnics/opennn/examples/simple_function_regression/data/simple_function_regression.csv", ';', true);

        // Variables

        const Vector<string> inputs_names = data_set.get_input_variables_names();
        const Vector<string> targets_names = data_set.get_target_variables_names();

//        data_set.set_training();
        data_set.split_instances_random(0.6,0.1,0.3);

        const Vector<Descriptives> inputs_descriptives = data_set.scale_inputs_minimum_maximum();
        const Vector<Descriptives> targets_descriptives = data_set.scale_targets_minimum_maximum();

        // Neural network        

        NeuralNetwork neural_network(NeuralNetwork::Approximation, {1, 2, 1});

        neural_network.set_inputs_names(inputs_names);
        neural_network.set_outputs_names(targets_names);

        ScalingLayer* scaling_layer_pointer = neural_network.get_scaling_layer_pointer();
        scaling_layer_pointer->set_descriptives(inputs_descriptives);

        UnscalingLayer* unscaling_layer_pointer = neural_network.get_unscaling_layer_pointer();
        unscaling_layer_pointer->set_descriptives(targets_descriptives);

        // Training strategy

        TrainingStrategy training_strategy(&neural_network, &data_set);

        training_strategy.set_loss_method(TrainingStrategy::LossMethod::SUM_SQUARED_ERROR);

        QuasiNewtonMethod* quasi_Newton_method_pointer = training_strategy.get_quasi_Newton_method_pointer();

//        cout << training_strategy.get_loss_index_pointer()->calculate_training_loss_gradient() << endl;
//        quasi_Newton_method_pointer->set_epochs_number(1000);

//        quasi_Newton_method_pointer->set_training_initial_batch_size(11);

        quasi_Newton_method_pointer->set_display_period(10);

//        quasi_Newton_method_pointer->set_maximum_iterations_number(1000);

        const OptimizationAlgorithm::Results training_strategy_results = training_strategy.perform_training();

        // Testing analysis

//        data_set.set_testing();

        TestingAnalysis testing_analysis(&neural_network, &data_set);

        const TestingAnalysis::LinearRegressionAnalysis linear_regression_results = testing_analysis.perform_linear_regression_analysis()[0];
        cout << "Correlation    : " << linear_regression_results.correlation << endl;

        // Save results

//        data_set.save("../data/data_set.xml");

//        neural_network.save("../data/neural_network.xml");
//        neural_network.save_expression("../data/expression.txt");

//        training_strategy.save("../data/training_strategy.xml");
//        training_strategy_results.save("../data/training_strategy_results.dat");

//        linear_regression_results.save("../data/linear_regression_analysis_results.dat");

        return 0;
    }
    catch(exception& e)
    {
        cerr << e.what() << endl;

        return 1;
    }
}  


// OpenNN: Open Neural Networks Library.
// Copyright (C) 2005-2019 Artificial Intelligence Techniques SL
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

//   OpenNN: Open Neural Networks Library
//   www.opennn.net
//
//   W E I G H T E D   S Q U A R E D   E R R O R    C L A S S   H E A D E R
//
//   Artificial Intelligence Techniques SL
//   artelnics@artelnics.com

#ifndef WEIGHTEDSQUAREDERROR_H
#define WEIGHTEDSQUAREDERROR_H

// System includes

#include <string>
#include <sstream>
#include <iostream>
#include <fstream>
#include <limits>
#include <math.h>

// OpenNN includes

#include "loss_index.h"
#include "data_set.h"



#include "tinyxml2.h"

namespace OpenNN
{

/// This class represents the weighted squared error term.

///
/// The weighted squared error measures the difference between the outputs from a neural network and the targets in a data set.
/// This functional is used in data modeling problems, such as function regression, 
/// classification and time series prediction.

class WeightedSquaredError : public LossIndex
{

public:

   // DEFAULT CONSTRUCTOR

   explicit WeightedSquaredError();

   // NEURAL NETWORK CONSTRUCTOR

   explicit WeightedSquaredError(NeuralNetwork*);

   // DATA SET CONSTRUCTOR

   explicit WeightedSquaredError(DataSet*);

   // DATA SET & NEURAL NETWORK CONSTRUCTOR
   explicit WeightedSquaredError(NeuralNetwork*, DataSet*);

   // XML CONSTRUCTOR

   explicit WeightedSquaredError(const tinyxml2::XMLDocument&);

   // COPY CONSTRUCTOR

   WeightedSquaredError(const WeightedSquaredError&);

   

   virtual ~WeightedSquaredError();

   // STRUCTURES

   

   // Get methods

   double get_positives_weight() const;
   double get_negatives_weight() const;

   double get_training_normalization_coefficient() const;
   double get_selection_normalization_coefficient() const;

   // Set methods

   // Error methods

   void set_default();

   void set_positives_weight(const double&);
   void set_negatives_weight(const double&);

   void set_training_normalization_coefficient(const double&);
   void set_selection_normalization_coefficient(const double&);

   void set_weights(const double&, const double&);

   void set_weights();

   void set_training_normalization_coefficient();
   void set_selection_normalization_coefficient();

   double calculate_batch_error(const Vector<size_t>&) const;
   double calculate_batch_error(const Vector<size_t>&, const Vector<double>&) const;

   Vector<double> calculate_training_error_gradient() const;

   LossIndex::FirstOrderLoss calculate_first_order_loss() const;
   LossIndex::FirstOrderLoss calculate_batch_first_order_loss(const Vector<size_t>&) const;

   Tensor<double> calculate_output_gradient(const Tensor<double>&, const Tensor<double>&) const;

   // Error terms methods

   Vector<double> calculate_training_error_terms(const Vector<double>&) const;
   Vector<double> calculate_training_error_terms(const Tensor<double>&, const Tensor<double>&) const;

   LossIndex::SecondOrderLoss calculate_terms_second_order_loss() const;

   string get_error_type() const;
   string get_error_type_text() const;

   // Serialization methods

   tinyxml2::XMLDocument* to_XML() const;   
   void from_XML(const tinyxml2::XMLDocument&);

   void write_XML(tinyxml2::XMLPrinter&) const;

   string object_to_string() const;

private:

   /// Weight for the positives for the calculation of the error.

   double positives_weight;

   /// Weight for the negatives for the calculation of the error.

   double negatives_weight;

   /// Coefficient of normalization for the calculation of the training error.

   double training_normalization_coefficient;

   /// Coefficient of normalization for the calculation of the selection error.

   double selection_normalization_coefficient;
};

}

#endif


// OpenNN: Open Neural Networks Library.
// Copyright(C) 2005-2019 Artificial Intelligence Techniques, SL.
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

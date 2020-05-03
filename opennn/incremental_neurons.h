//   OpenNN: Open Neural Networks Library
//   www.opennn.net
//
//   I N C R E M E N T A L   N E U R O N S   C L A S S   H E A D E R
//
//   Artificial Intelligence Techniques SL
//   artelnics@artelnics.com

#ifndef INCREMENTALNEURONS_H
#define INCREMENTALNEURONS_H

// System includes

#include <iostream>
#include <fstream>
#include <algorithm>
#include <functional>
#include <limits>
#include <cmath>
#include <ctime>

// OpenNN includes

#include "vector.h"
#include "matrix.h"
#include "training_strategy.h"
#include "neurons_selection.h"
#include "tinyxml2.h"

namespace OpenNN
{

/// This concrete class represents an incremental algorithm for the NeuronsSelection as part of the ModelSelection[1] class.

/// [1] Neural Designer "Model Selection Algorithms in Predictive Analytics." \ref https://www.neuraldesigner.com/blog/model-selection

class IncrementalNeurons : public NeuronsSelection
{

public:

    // Constructors

    explicit IncrementalNeurons();

    explicit IncrementalNeurons(TrainingStrategy*);

    explicit IncrementalNeurons(const tinyxml2::XMLDocument&);

    explicit IncrementalNeurons(const string&);

    // Destructor

    virtual ~IncrementalNeurons();

    /// This structure contains the training results for the incremental order method.

    struct IncrementalNeuronsResults : public NeuronsSelection::Results
    {
        /// Default constructor.

        explicit IncrementalNeuronsResults() : NeuronsSelection::Results()
        {
        }

        /// Destructor.

        virtual ~IncrementalNeuronsResults()
        {
        }
    };

    // Get methods

    const size_t& get_step() const;

    const size_t& get_maximum_selection_failures() const;

    // Set methods

    void set_default();

    void set_step(const size_t&);

    void set_maximum_selection_failures(const size_t&);

    // Order selection methods

    IncrementalNeuronsResults* perform_neurons_selection();

    // Serialization methods

    Matrix<string> to_string_matrix() const;

    tinyxml2::XMLDocument* to_XML() const;
    void from_XML(const tinyxml2::XMLDocument&);

    void write_XML(tinyxml2::XMLPrinter&) const;    

    void save(const string&) const;
    void load(const string&);

private:

   /// Number of neurons added at each iteration.

   size_t step;

   /// Maximum number of iterations at which the selection error increases.

   size_t maximum_selection_failures;

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

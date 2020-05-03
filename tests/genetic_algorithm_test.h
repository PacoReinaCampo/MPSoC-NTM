//   OpenNN: Open Neural Networks Library
//   www.opennn.net
//
//   G E N E T I C   A L G O R I T H M   T E S T   C L A S S   H E A D E R 
//
//   Artificial Intelligence Techniques SL
//   artelnics@artelnics.com                                           

#ifndef GENETICALGORITHMTEST_H
#define GENETICALGORITHMTEST_H

// Unit testing includes

#include "unit_testing.h"

using namespace OpenNN;


class GeneticAlgorithmTest : public UnitTesting
{

#define	STRING(x) #x
#define TOSTRING(x) STRING(x)
#define LOG __FILE__ ":" TOSTRING(__LINE__)"\n"

public:

   // CONSTRUCTOR

   explicit GeneticAlgorithmTest();


   

   virtual ~GeneticAlgorithmTest();


   

   // Constructor and destructor methods

   void test_constructor();
   void test_destructor();

   // Set methods

   void test_set_default();

   // Population methods

   void test_initialize_population();

   void test_calculate_fitness();

   // Selection methods

   void test_perform_selection();

   // Crossover methods

   void test_perform_crossover();

   // Mutation methods

   void test_perform_mutation();

   // Inputs selection methods

   void test_perform_inputs_selection();

   // Serialization methods

   void test_to_XML();

   void test_from_XML();

   // Unit testing methods

   void run_test_case();

};


#endif

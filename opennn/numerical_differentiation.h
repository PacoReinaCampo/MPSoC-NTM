//   OpenNN: Open Neural Networks Library
//   www.opennn.net
//
//   N U M E R I C A L   D I F F E R E N T I A T I O N   C L A S S   H E A D E R
//
//   Artificial Intelligence Techniques SL
//   artelnics@artelnics.com


#ifndef NUMERICALDIFFERENTIATION_H
#define NUMERICALDIFFERENTIATION_H

// System includes

#include<iostream>

// OpenNN includes

#include "vector.h"
#include "matrix.h"



#include "tinyxml2.h"

   
namespace OpenNN
{

/// This class contains methods for numerical differentiation of functions. 

///
/// In particular it implements the forward and central differences methods for derivatives, Jacobians, hessians or hessian forms.

class NumericalDifferentiation 
{

public:

   // Constructors

   explicit NumericalDifferentiation();

   NumericalDifferentiation(const NumericalDifferentiation&);

   // Destructor

   virtual ~NumericalDifferentiation();

   /// Enumeration of available methods for numerical differentiation.

   enum NumericalDifferentiationMethod{ForwardDifferences, CentralDifferences};  

   const NumericalDifferentiationMethod& get_numerical_differentiation_method() const;
   string write_numerical_differentiation_method() const;
   
   const size_t& get_precision_digits() const;

   const bool& get_display() const;

   void set(const NumericalDifferentiation&);

   void set_numerical_differentiation_method(const NumericalDifferentiationMethod&);
   void set_numerical_differentiation_method(const string&);

   void set_precision_digits(const size_t&);

   void set_display(const bool&);

   void set_default();

   double calculate_h(const double&) const;

   Vector<double> calculate_h(const Vector<double>&) const;
   Tensor<double> calculate_h(const Tensor<double>&) const;

   Vector<double> calculate_backward_differences_derivatives(const Vector<double>&, const Vector<double>&) const;

   // Serialization methods

   tinyxml2::XMLDocument* to_XML() const;   
   void from_XML(const tinyxml2::XMLDocument&);   

   void write_XML(tinyxml2::XMLPrinter&) const;

   /// Returns the derivative of a function using the forward differences method. 
   /// @param t  Object constructor containing the member method to differentiate.  
   /// @param f Pointer to the member method.
   /// @param x Differentiation point. 

   template<class T> 
   double calculate_forward_differences_derivatives(const T& t, double(T::*f)(const double&) const, const double& x) const
   {
      const double y = (t.*f)(x);

      const double h = calculate_h(x);

	  const double y_forward = (t.*f)(x + h);
     
      const double d = (y_forward - y)/h;
     
      return d;
   }

   /// Returns the derivative of a function using the central differences method. 
   /// @param t  Object constructor containing the member method to differentiate.  
   /// @param f Pointer to the member method.
   /// @param x Differentiation point. 

   template<class T>  
   double calculate_central_differences_derivatives(const T& t, double(T::*f)(const double&) const , const double& x) const
   {
      const double h = calculate_h(x);

	  const double y_forward = (t.*f)(x+h);

	  const double y_backward = (t.*f)(x-h);
     
      const double d = (y_forward - y_backward)/(2.0*h);

      return d;
   }


   /// Returns the derivative of a function acording to the numerical differentiation method to be used. 
   /// @param t  Object constructor containing the member method to differentiate.  
   /// @param f Pointer to the member method.
   /// @param x Differentiation point. 

   template<class T> 
   double calculate_derivatives(const T& t, double(T::*f)(const double&) const , const double& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_derivatives(t, f, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_derivatives(t, f, x));
    	 }   	     
      }

      return 0.0;
   }


   /// Returns the derivatives of a vector function using the forward differences method. 
   /// @param t  Object constructor containing the member method to differentiate.  
   /// @param f Pointer to the member method.
   /// @param x Input vector. 

   template<class T> 
   Vector<double> calculate_forward_differences_derivatives(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      const Vector<double> h = calculate_h(x);

	  const Vector<double> y = (t.*f)(x);

      const Vector<double> x_forward = x + h;     
	  const Vector<double> y_forward = (t.*f)(x_forward);

	  const Vector<double> d = (y_forward - y)/h;

      return d;
   }


   template<class T>
   Tensor<double> calculate_forward_differences_derivatives(const T& t, Tensor<double>(T::*f)(const Tensor<double>&) const, const Tensor<double>& x) const
   {
      const Tensor<double> h = calculate_h(x);

      const Tensor<double> y = (t.*f)(x);

      const Tensor<double> x_forward = x + h;
      const Tensor<double> y_forward = (t.*f)(x_forward);

      const Tensor<double> d = (y_forward - y)/h;

      return d;
   }


   /// Returns the derivatives of a vector function using the central differences method. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_central_differences_derivatives(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      const Vector<double> h = calculate_h(x);
     
      const Vector<double> x_forward = x + h;
      const Vector<double> x_backward = x - h;

	  const Vector<double> y_forward = (t.*f)(x_forward);
	  const Vector<double> y_backward = (t.*f)(x_backward);

	  const Vector<double> y = (t.*f)(x);

      const Vector<double> d = (y_forward - y_backward)/(h*2.0);

      return d;
   }


   template<class T>
   Tensor<double> calculate_central_differences_derivatives(const T& t, Tensor<double>(T::*f)(const Tensor<double>&) const, const Tensor<double>& x) const
   {
      const Tensor<double> h = calculate_h(x);

      const Tensor<double> x_forward = x + h;
      const Tensor<double> x_backward = x - h;

      const Tensor<double> y_forward = (t.*f)(x_forward);
      const Tensor<double> y_backward = (t.*f)(x_backward);

      const Tensor<double> y = (t.*f)(x);

      const Tensor<double> d = (y_forward - y_backward)/(h*2.0);

      return d;
   }


   /// Returns the derivatives of a vector function acording to the numerical differentiation method to be used. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_derivatives(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_derivatives(t, f, x));
         }	     

         case CentralDifferences:
         {
            return(calculate_central_differences_derivatives(t, f, x));
    	 }

      }

      return Vector<double>();
   }


   template<class T>
   Tensor<double> calculate_derivatives(const T& t, Tensor<double>(T::*f)(const Tensor<double>&) const, const Tensor<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return calculate_forward_differences_derivatives(t, f, x);
         }

         case CentralDifferences:
         {
            return calculate_central_differences_derivatives(t, f, x);
         }

      }

      return Tensor<double>();
   }


   /// Returns the derivatives of a vector function using the forward differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_forward_differences_derivatives(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      const Vector<double> y = (t.*f)(dummy, x);

      const Vector<double> h = calculate_h(x);     
      const Vector<double> x_forward = x + h;     

	  const Vector<double> y_forward = (t.*f)(dummy, x_forward);

	  const Vector<double> d = (y_forward - y)/h;

      return d;
   }


   /// Returns the derivatives of a vector function using the central differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_central_differences_derivatives(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      const Vector<double> h = calculate_h(x);     

      const Vector<double> x_forward = x + h;
      const Vector<double> x_backward = x - h;

	  const Vector<double> y_forward = (t.*f)(dummy, x_forward);
	  const Vector<double> y_backward = (t.*f)(dummy, x_backward);

      const Vector<double> d = (y_forward - y_backward)/(h*2.0);

      return d;
   }


   /// Returns the derivatives of a vector function according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_derivatives(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_derivatives(t, f, dummy, x));
         }

         case CentralDifferences:
         {
           return(calculate_central_differences_derivatives(t, f, dummy, x));
    	 } 	     
      }

      return Vector<double>();
   }


   // SECOND DERIVATIVE METHODS

   /// Returns the second derivative of a function using the forward differences method. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Differentiation point. 

   template<class T> 
   double calculate_forward_differences_second_derivatives(const T& t, double(T::*f)(const double&) const, const double& x) const
   {   
      const double h = calculate_h(x);

      const double x_forward_2 = x + 2.0*h;

      const double y_forward_2 = (t.*f)(x_forward_2);

      const double x_forward = x + h;

      const double y_forward = (t.*f)(x_forward);

      const double y = (t.*f)(x);
       
      return (y_forward_2 - 2*y_forward + y)/pow(h, 2);
   }


   /// Returns the second derivative of a function using the central differences method.
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Differentiation point. 

   template<class T> 
   double calculate_central_differences_second_derivatives(const T& t, double(T::*f)(const double&) const , const double& x) const
   {
      const double h = calculate_h(x);

      const double x_forward_2 = x + 2.0*h;

      const double y_forward_2 = (t.*f)(x_forward_2);

      const double x_forward = x + h;

      const double y_forward = (t.*f)(x_forward);

      const double y = (t.*f)(x);

      const double x_backward = x - h;  

      const double y_backward = (t.*f)(x_backward);

      const double x_backward_2 = x - 2.0*h;

      const double y_backward_2 = (t.*f)(x_backward_2);
    
      const double d2 = (-y_forward_2 + 16.0*y_forward -30.0*y + 16.0*y_backward - y_backward_2)/(12.0*pow(h, 2));  

      return(d2);
   }


   /// Returns the second derivative of a function acording to the numerical differentiation method to be used.
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Differentiation point. 

   template<class T> 
   double calculate_second_derivatives(const T& t, double(T::*f)(const double&) const , const double& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_second_derivatives(t, f, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_second_derivatives(t, f, x));
    	 }   	    
      }

      return 0.0;
   }


   /// Returns the second derivative of a vector function using the forward differences method. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_forward_differences_second_derivatives(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      const Vector<double> y = (t.*f)(x);

      const Vector<double> h = calculate_h(x);

      const Vector<double> x_forward = x + h;
      const Vector<double> x_forward_2 = x + h*2.0;

      const Vector<double> y_forward = (t.*f)(x_forward);
      const Vector<double> y_forward_2 = (t.*f)(x_forward_2);

      return (y_forward_2 - y_forward*2.0 + y)/(h*h);
   }


   /// Returns the second derivative of a vector function using the central differences method. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_central_differences_second_derivatives(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {      
      const Vector<double> h = calculate_h(x);

      const Vector<double> x_forward = x + h;
      const Vector<double> x_forward_2 = x + h*2.0;

      const Vector<double> x_backward = x - h;
      const Vector<double> x_backward_2 = x - h*2.0;

      const Vector<double> y = (t.*f)(x);

      const Vector<double> y_forward = (t.*f)(x_forward);
      const Vector<double> y_forward_2 = (t.*f)(x_forward_2);

      const Vector<double> y_backward = (t.*f)(x_backward);
      const Vector<double> y_backward_2 = (t.*f)(x_backward_2);

      return (y_forward_2*-1.0 + y_forward*16.0 + y*-30.0 + y_backward*16.0 + y_backward_2*-1.0)/(h*h*12.0);
   }


   /// Returns the second derivative of a vector function acording to the numerical differentiation method to be used. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_second_derivatives(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_second_derivatives(t, f, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_second_derivatives(t, f, x));
    	 }
      }

      return Vector<double>();
   }


   /// Returns the second derivative of a vector function using the forward differences method.
   /// @param t : Object constructor containing the member method to differentiate.
   /// @param f: Pointer to the member method.
   /// @param dummy_1: Dummy integer for the method prototype.
   /// @param x1: Input vector.
   /// @param dummy_2: Dummy integer for the method prototype.
   /// @param x2: Input vector.

   template<class T>
   Matrix<double> calculate_forward_differences_second_derivatives(const T& t, double(T::*f)(const size_t&, const Vector<double>&, const size_t&, const Vector<double>&) const,
                                                                  const size_t& dummy_1, const Vector<double>& x1, const size_t& dummy_2,const Vector<double>& x2) const
   {
       const size_t n = x1.size();
       const size_t m = x2.size();

      Matrix<double> M(n, m);

      double y = (t.*f)(dummy_1, x1, dummy_2, x2);

      double h1, h2;

      Vector<double> x1_forward(x1);
      Vector<double> x1_forward_2(x1);

      Vector<double> x2_forward(x2);
      Vector<double> x2_forward_2(x2);

      double y_forward, y_forward_2;

      for(size_t i = 0; i < n; i++)
      {
          h1 = calculate_h(x1[i]);

          x1_forward[i] += h1;

          x1_forward_2[i] += 2.0*h1;

          for(size_t j = 0; j < m; j++)
          {
              h2 = calculate_h(x2[j]);

              x2_forward[j] += h2;

              x2_forward_2[j] += 2.0*h2;

              y_forward = (t.*f)(dummy_1, x1_forward, dummy_2, x2_forward);

              y_forward_2 = (t.*f)(dummy_1, x1_forward_2, dummy_2, x2_forward_2);

              M(i,j) = (y_forward_2 - 2*y_forward + y)/(h1*h2);

              x2_forward[j] -= h2;

              x2_forward_2[j] -= 2.0*h2;
        }

      x1_forward[i] -= h1;

      x1_forward_2[i] -= 2.0*h1;

     }

      return(M);
   }


   /// Returns the second derivatives of a vector function using the forward differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_forward_differences_second_derivatives(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      const Vector<double> y = (t.*f)(dummy, x);

      const Vector<double> h = calculate_h(x);

      const Vector<double> x_forward = x + h;
      const Vector<double> x_forward_2 = x + h*2.0;

      const Vector<double> y_forward = (t.*f)(dummy, x_forward);
      const Vector<double> y_forward_2 = (t.*f)(dummy, x_forward_2);

      return (y_forward_2 - y_forward*2.0 + y)/(h*h);
   }


   // Vector<double> calculate_central_differences_second_derivatives(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t&, const Vector<double>&) const method

   /// Returns the second derivatives of a vector function using the central differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_central_differences_second_derivatives(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {      
      const Vector<double> h = calculate_h(x);

      const Vector<double> x_forward = x + h;
      const Vector<double> x_forward_2 = x + h*2.0;

      const Vector<double> x_backward = x - h;
      const Vector<double> x_backward_2 = x - h*2.0;

      const Vector<double> y = (t.*f)(dummy, x);

      const Vector<double> y_forward = (t.*f)(dummy, x_forward);
      const Vector<double> y_forward_2 = (t.*f)(dummy, x_forward_2);

      const Vector<double> y_backward = (t.*f)(dummy, x_backward);
      const Vector<double> y_backward_2 = (t.*f)(dummy, x_backward_2);

      return (y_forward_2*-1.0 + y_forward*16.0 + y*-30.0 + y_backward*16.0 + y_backward_2*-1.0)/(h*h*12.0);
   }


   /// Returns the second derivatives of a vector function acording to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_second_derivatives(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_second_derivatives(t, f, dummy, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_second_derivatives(t, f, dummy, x));
    	 }
      }

      return Vector<double>();
   }


   // GRADIENT METHODS

   /// Returns the gradient of a function of several dimensions using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_forward_differences_gradient(const T& t, double(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double h;

      double y = (t.*f)(x);
      
	  Vector<double> x_forward(x);
  
      double y_forward;

	  Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);
 
         x_forward[i] += h;
         y_forward = (t.*f)(x_forward);
         x_forward[i] -= h;

         g[i] = (y_forward - y)/h; 
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_central_differences_gradient(const T& t, double(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double h;

	  Vector<double> x_forward(x);
	  Vector<double> x_backward(x);
  
	  double y_forward;
      double y_backward;

      Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);

         x_forward[i] += h;
         y_forward = (t.*f)(x_forward);
         x_forward[i] -= h;

         x_backward[i] -= h;
         y_backward = (t.*f)(x_backward);
         x_backward[i] += h;

         g[i] = (y_forward - y_backward)/(2.0*h); 
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions acording to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_gradient(const T& t, double(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_gradient(t, f, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_gradient(t, f, x));
    	 }
      }

      return Vector<double>();
   }


   /// Returns the gradient of a function of several dimensions using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&). 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_forward_differences_gradient(const T& t, double(T::*f)(const Vector<double>&), const Vector<double>& x) const
   {
      const size_t n = x.size();

      double h;

      double y = (t.*f)(x);
      
	  Vector<double> x_forward(x);
  
      double y_forward;

	  Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);
 
         x_forward[i] += h;
         y_forward = (t.*f)(x_forward);
         x_forward[i] -= h;

         g[i] = (y_forward - y)/h; 
      }

      return g;
   }



   /// Returns the gradient of a function of several dimensions using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_central_differences_gradient(const T& t, double(T::*f)(const Vector<double>&), const Vector<double>& x) const
   {      

      const size_t n = x.size();

      double h;

	  Vector<double> x_forward(x);
	  Vector<double> x_backward(x);
  
	  double y_forward;
      double y_backward;

      Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);

         x_forward[i] += h;
         y_forward = (t.*f)(x_forward);
         x_forward[i] -= h;

         x_backward[i] -= h;
         y_backward = (t.*f)(x_backward);
         x_backward[i] += h;

         g[i] = (y_forward - y_backward)/(2.0*h); 
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions acording to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_gradient(const T& t, double(T::*f)(const Vector<double>&), const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_gradient(t, f, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_gradient(t, f, x));
    	 }
      }

      return Vector<double>();
   }


   /// Returns the gradient of a function of several dimensions using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&, const Vector<double>&) const. 
   /// The first vector argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_forward_differences_gradient(const T& t, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double h;

      const double y = (t.*f)(dummy, x);
      
      Vector<double> x_forward(x);
  
      double y_forward;

	  Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);
 
         x_forward[i] += h;
         y_forward = (t.*f)(dummy, x_forward);
         x_forward[i] -= h;

         g[i] = (y_forward - y)/h; 
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&, const Vector<double>&) const. 
   /// The first vector argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_central_differences_gradient(const T& t, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {    
      const size_t n = x.size();

      double h;

      Vector<double> x_forward(x);
      Vector<double> x_backward(x);
  
      double y_forward;
      double y_backward;

      Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);
 
         x_forward[i] += h;
         y_forward = (t.*f)(dummy, x_forward);
         x_forward[i] -= h;

         x_backward[i] -= h;
         y_backward = (t.*f)(dummy, x_backward);
         x_backward[i] += h;

         g[i] = (y_forward - y_backward)/(2.0*h); 
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions acording to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&, const Vector<double>&) const. 
   /// The first vector argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_gradient(const T& t, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_gradient(t, f, dummy, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_gradient(t, f, dummy, x));
    	 }
      }

      return Vector<double>();
   }


   /// Returns the gradient of a function of several dimensions using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is used for the function definition, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_forward_differences_gradient(const T& t, double(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double h;

      double y = (t.*f)(dummy, x);
      
	  Vector<double> x_forward(x);
  
      double y_forward;

	  Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);
 
         x_forward[i] += h;
         y_forward = (t.*f)(dummy, x_forward);
         x_forward[i] -= h;

         g[i] = (y_forward - y)/h; 
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions using the forward differences method.
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const.
   /// The first integer argument is used for the function definition, differentiation is performed with respect to the second vector argument.
   /// @param t : Object constructor containing the member method to differentiate.
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector.

   template<class T>
   Vector<double> calculate_forward_differences_gradient(const T& t, double(T::*f)(const Vector<size_t>&, const Vector<double>&) const, const Vector<size_t>& dummy, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double h;

      double y = (t.*f)(dummy, x);

      Vector<double> x_forward(x);

      double y_forward;

      Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);

         x_forward[i] += h;

         y_forward = (t.*f)(dummy, x_forward);
         x_forward[i] -= h;

         g[i] = (y_forward - y)/h;
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is used for the function definition, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_central_differences_gradient(const T& t, double(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {      
      const size_t n = x.size();

      double h;

	  Vector<double> x_forward(x);
	  Vector<double> x_backward(x);
  
	  double y_forward;
      double y_backward;

      Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);
 
         x_forward[i] += h;
         y_forward = (t.*f)(dummy, x_forward);
         x_forward[i] -= h;

         x_backward[i] -= h;
         y_backward = (t.*f)(dummy, x_backward);
         x_backward[i] += h;

         g[i] = (y_forward - y_backward)/(2.0*h); 
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions using the central differences method.
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const.
   /// The first integer argument is used for the function definition, differentiation is performed with respect to the second vector argument.
   /// @param t : Object constructor containing the member method to differentiate.
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector.

   template<class T>
   Vector<double> calculate_central_differences_gradient(const T& t, Vector<double>(T::*f)(const size_t&, const Matrix<double>&) const, const size_t& dummy, const Matrix<double>& x) const
   {
      const size_t n = x.size();

      double h;

      Vector<double> x_forward(x);
      Vector<double> x_backward(x);

      double y_forward;
      double y_backward;

      Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);

         x_forward[i] += h;
         y_forward = (t.*f)(dummy, x_forward);
         x_forward[i] -= h;

         x_backward[i] -= h;
         y_backward = (t.*f)(dummy, x_backward);
         x_backward[i] += h;

         g[i] = (y_forward - y_backward)/(2.0*h);
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions using the central differences method.
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const.
   /// The first integer argument is used for the function definition, differentiation is performed with respect to the second vector argument.
   /// @param t : Object constructor containing the member method to differentiate.
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector.

   template<class T>
   Vector<double> calculate_central_differences_gradient(const T& t, double(T::*f)(const Vector<size_t>&, const Vector<double>&) const, const Vector<size_t>& dummy, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double h;
      Vector<double> x_forward(x);
      Vector<double> x_backward(x);

      double y_forward;
      double y_backward;

      Vector<double> g(n);

      for(size_t i = 0; i < n; i++)
      {
         h = calculate_h(x[i]);

         x_forward[i] += h;
         y_forward = (t.*f)(dummy, x_forward);
         x_forward[i] -= h;

         x_backward[i] -= h;
         y_backward = (t.*f)(dummy, x_backward);
         x_backward[i] += h;

         g[i] = (y_forward - y_backward)/(2.0*h);
      }

      return g;
   }


   /// Returns the gradient of a function of several dimensions acording to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is used for the function definition, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Vector<double> calculate_gradient(const T& t, double(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_gradient(t, f, dummy, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_gradient(t, f, dummy, x));
    	 }
      }

      return Vector<double>();
   }


   /// Returns the gradient of a function of several dimensions acording to the numerical differentiation method to be used.
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const.
   /// The first integer argument is used for the function definition, differentiation is performed with respect to the second vector argument.
   /// @param t : Object constructor containing the member method to differentiate.
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector.

   template<class T>
   Vector<double> calculate_gradient(const T& t, double(T::*f)(const Vector<size_t>&, const Vector<double>&) const, const Vector<size_t>& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_gradient(t, f, dummy, x));
         }

         case CentralDifferences:
         {
            return(calculate_central_differences_gradient(t, f, dummy, x));
         }
      }

      return Vector<double>();
   }


   template<class T>
   Matrix<double> calculate_central_differences_gradient_matrix(const T& t, Vector<double>(T::*f)(const size_t&, const Matrix<double>&) const, const size_t& integer, const Matrix<double>& x) const
   {
       const size_t rows_number = x.get_rows_number();
       const size_t columns_number = x.get_columns_number();

      Matrix<double> gradient(rows_number, columns_number);

      double h;
      Matrix<double> x_forward(x);
      Matrix<double> x_backward(x);

      double y_forward;
      double y_backward;

      for(size_t i = 0; i < rows_number; i++)
      {
          for(size_t j = 0; j < columns_number; j++)
          {
             h = calculate_h(x(i,j));

             x_forward(i,j) += h;
             y_forward = (t.*f)(integer, x_forward)[i];
             x_forward(i,j) -= h;

             x_backward(i,j) -= h;
             y_backward = (t.*f)(integer, x_backward)[i];
             x_backward(i,j) += h;

             gradient(i,j) = (y_forward - y_backward)/(2.0*h);
          }
      }

      return gradient;
   }

   // HESSIAN METHODS

   /// Returns the hessian matrix of a function of several dimensions using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_forward_differences_hessian(const T& t, double(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      const size_t n = x.size();

      Matrix<double> H(n, n);

      double h_i;
      double h_j;

      double y = (t.*f)(x);

      Vector<double> x_forward_2i(x);
      Vector<double> x_forward_ij(x);
      Vector<double> x_forward_i(x);
      Vector<double> x_forward_j(x);

      double y_forward_2i;
      double y_forward_ij;
      double y_forward_i;
      double y_forward_j;

      for(size_t i = 0; i < n; i++)
      {
         h_i = calculate_h(x[i]);

         x_forward_i[i] += h_i;       
         y_forward_i = (t.*f)(x_forward_i);
         x_forward_i[i] -= h_i;       

         x_forward_2i[i] += 2.0*h_i;       
         y_forward_2i = (t.*f)(x_forward_2i);
         x_forward_2i[i] -= 2.0*h_i;       

         H(i,i) = (y_forward_2i - 2*y_forward_i + y)/pow(h_i, 2);  

         for(size_t j = i; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_forward_j[j] += h_j;       
            y_forward_j = (t.*f)(x_forward_j);
            x_forward_j[j] -= h_j;       

            x_forward_ij[i] += h_i; 
            x_forward_ij[j] += h_j; 
            y_forward_ij = (t.*f)(x_forward_ij);   
            x_forward_ij[i] -= h_i; 
            x_forward_ij[j] -= h_j; 
            
            H(i,j) = (y_forward_ij - y_forward_i - y_forward_j + y)/(h_i*h_j);
         } 
      }

      for(size_t i = 0; i < n; i++)
      {
         for(size_t j = 0; j < i; j++)
         {
            H(i,j) = H(j,i);
         }
      }

      return(H);
   }


   // Matrix<double> calculate_central_differences_hessian(const T&, double(T::*f)(const Vector<double>&) const, const Vector<double>&) const method

   /// Returns the hessian matrix of a function of several dimensions using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_central_differences_hessian(const T& t, double(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double y = (t.*f)(x);

      Matrix<double> H(n, n);

      double h_i;
      double h_j;

      Vector<double> x_backward_2i(x);
      Vector<double> x_backward_i(x);

      Vector<double> x_forward_i(x);
      Vector<double> x_forward_2i(x);      

      Vector<double> x_backward_ij(x);
      Vector<double> x_forward_ij(x);

      Vector<double> x_backward_i_forward_j(x);
      Vector<double> x_forward_i_backward_j(x);

      double y_backward_2i;
      double y_backward_i;

      double y_forward_i;
      double y_forward_2i;
   
      double y_backward_ij;
      double y_forward_ij;

      double y_backward_i_forward_j;
      double y_forward_i_backward_j;

      for(size_t i = 0; i < n; i++)
      {
         h_i = calculate_h(x[i]);

         x_backward_2i[i] -= 2.0*h_i; 
         y_backward_2i = (t.*f)(x_backward_2i);
         x_backward_2i[i] += 2.0*h_i; 

         x_backward_i[i] -= h_i; 
         y_backward_i = (t.*f)(x_backward_i);
         x_backward_i[i] += h_i; 

         x_forward_i[i] += h_i; 
         y_forward_i = (t.*f)(x_forward_i);
         x_forward_i[i] -= h_i; 

         x_forward_2i[i] += 2.0*h_i; 
         y_forward_2i = (t.*f)(x_forward_2i);
         x_forward_2i[i] -= 2.0*h_i; 

         H(i,i) = (-y_forward_2i + 16.0*y_forward_i -30.0*y + 16.0*y_backward_i - y_backward_2i)/(12.0*pow(h_i, 2));  

         for(size_t j = i; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_backward_ij[i] -= h_i;  
            x_backward_ij[j] -= h_j;  
            y_backward_ij = (t.*f)(x_backward_ij);   
            x_backward_ij[i] += h_i;  
            x_backward_ij[j] += h_j;  

            x_forward_ij[i] += h_i;  
            x_forward_ij[j] += h_j;  
            y_forward_ij = (t.*f)(x_forward_ij);   
            x_forward_ij[i] -= h_i;  
            x_forward_ij[j] -= h_j;  
            
            x_backward_i_forward_j[i] -= h_i;
            x_backward_i_forward_j[j] += h_j;
            y_backward_i_forward_j = (t.*f)(x_backward_i_forward_j);   
            x_backward_i_forward_j[i] += h_i;
            x_backward_i_forward_j[j] -= h_j;

            x_forward_i_backward_j[i] += h_i;
            x_forward_i_backward_j[j] -= h_j;
            y_forward_i_backward_j = (t.*f)(x_forward_i_backward_j);   
            x_forward_i_backward_j[i] -= h_i;
            x_forward_i_backward_j[j] += h_j;
 
            H(i,j) = (y_forward_ij - y_forward_i_backward_j - y_backward_i_forward_j + y_backward_ij)/(4.0*h_i*h_j);
         }
      }

      for(size_t i = 0; i < n; i++)
      {
         for(size_t j = 0; j < i; j++)
         {
            H(i,j) = H(j,i);
         }
      }

      return(H);
   }


   /// Returns the hessian matrix of a function of several dimensions acording to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_hessian(const T& t, double(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_hessian(t, f, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_hessian(t, f, x));
         }
      }

      return Matrix<double>();
   }


   // Matrix<double> calculate_forward_differences_hessian(const T&, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const method

   /// Returns the hessian matrix of a function of several dimensions using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&, const Vector<double>&) const. 
   /// The first vector argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_forward_differences_hessian(const T& t, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {
      const size_t n = x.size();

      Matrix<double> H(n, n);

      double h_i;
      double h_j;

      double y = (t.*f)(dummy, x);

      Vector<double> x_forward_2i(x);
      Vector<double> x_forward_ij(x);
      Vector<double> x_forward_i(x);
      Vector<double> x_forward_j(x);

      double y_forward_2i;
      double y_forward_ij;
      double y_forward_i;
      double y_forward_j;

      for(size_t i = 0; i < n; i++)
      {
         h_i = calculate_h(x[i]);

         x_forward_i[i] += h_i;       
         y_forward_i = (t.*f)(dummy, x_forward_i);
         x_forward_i[i] -= h_i;       

         x_forward_2i[i] += 2.0*h_i;       
         y_forward_2i = (t.*f)(dummy, x_forward_2i);
         x_forward_2i[i] -= 2.0*h_i;       

         H(i,i) = (y_forward_2i - 2*y_forward_i + y)/pow(h_i, 2);  

         for(size_t j = i; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_forward_j[j] += h_j;       
            y_forward_j = (t.*f)(dummy, x_forward_j);
            x_forward_j[j] -= h_j;       

            x_forward_ij[i] += h_i; 
            x_forward_ij[j] += h_j; 
            y_forward_ij = (t.*f)(dummy, x_forward_ij);   
            x_forward_ij[i] -= h_i; 
            x_forward_ij[j] -= h_j; 
            
            H(i,j) = (y_forward_ij - y_forward_i - y_forward_j + y)/(h_i*h_j);
         } 
      }

      for(size_t i = 0; i < n; i++)
      {
         for(size_t j = 0; j < i; j++)
         {
            H(i,j) = H(j,i);
         }
      }

      return(H);
   }


   // Matrix<double> calculate_central_differences_hessian(const T&, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>&, const Vector<double>&) const method

   /// Returns the hessian matrix of a function of several dimensions using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&, const Vector<double>&) const. 
   /// The first vector argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_central_differences_hessian(const T& t, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double y = (t.*f)(dummy, x);

      Matrix<double> H(n, n);

      double h_i;
      double h_j;

      Vector<double> x_backward_2i(x);
      Vector<double> x_backward_i(x);

      Vector<double> x_forward_i(x);
      Vector<double> x_forward_2i(x);      

      Vector<double> x_backward_ij(x);
      Vector<double> x_forward_ij(x);

      Vector<double> x_backward_i_forward_j(x);
      Vector<double> x_forward_i_backward_j(x);

      double y_backward_2i;
      double y_backward_i;

      double y_forward_i;
      double y_forward_2i;
   
      double y_backward_ij;
      double y_forward_ij;

      double y_backward_i_forward_j;
      double y_forward_i_backward_j;

      for(size_t i = 0; i < n; i++)
      {
         h_i = calculate_h(x[i]);

         x_backward_2i[i] -= 2.0*h_i; 
         y_backward_2i = (t.*f)(dummy, x_backward_2i);
         x_backward_2i[i] += 2.0*h_i; 

         x_backward_i[i] -= h_i; 
         y_backward_i = (t.*f)(dummy, x_backward_i);
         x_backward_i[i] += h_i; 

         x_forward_i[i] += h_i; 
         y_forward_i = (t.*f)(dummy, x_forward_i);
         x_forward_i[i] -= h_i; 

         x_forward_2i[i] += 2.0*h_i; 
         y_forward_2i = (t.*f)(dummy, x_forward_2i);
         x_forward_2i[i] -= 2.0*h_i; 

         H(i,i) = (-y_forward_2i + 16.0*y_forward_i -30.0*y + 16.0*y_backward_i - y_backward_2i)/(12.0*pow(h_i, 2));  

         for(size_t j = i; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_backward_ij[i] -= h_i;  
            x_backward_ij[j] -= h_j;  
            y_backward_ij = (t.*f)(dummy, x_backward_ij);   
            x_backward_ij[i] += h_i;  
            x_backward_ij[j] += h_j;  

            x_forward_ij[i] += h_i;  
            x_forward_ij[j] += h_j;  
            y_forward_ij = (t.*f)(dummy, x_forward_ij);   
            x_forward_ij[i] -= h_i;  
            x_forward_ij[j] -= h_j;  
            
            x_backward_i_forward_j[i] -= h_i;
            x_backward_i_forward_j[j] += h_j;
            y_backward_i_forward_j = (t.*f)(dummy, x_backward_i_forward_j);   
            x_backward_i_forward_j[i] += h_i;
            x_backward_i_forward_j[j] -= h_j;

            x_forward_i_backward_j[i] += h_i;
            x_forward_i_backward_j[j] -= h_j;
            y_forward_i_backward_j = (t.*f)(dummy, x_forward_i_backward_j);   
            x_forward_i_backward_j[i] -= h_i;
            x_forward_i_backward_j[j] += h_j;
 
            H(i,j) = (y_forward_ij - y_forward_i_backward_j - y_backward_i_forward_j + y_backward_ij)/(4.0*h_i*h_j);
         }
      }

      for(size_t i = 0; i < n; i++)
      {
         for(size_t j = 0; j < i; j++)
         {
            H(i,j) = H(j,i);
         }
      }

      return(H);
   }


   // Matrix<double> calculate_hessian(const T&, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>&, const Vector<double>&) const method

   /// Returns the hessian matrix of a function of several dimensions according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const Vector<double>&, const Vector<double>&) const. 
   /// The first vector argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_hessian(const T& t, double(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_hessian(t, f, dummy, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_hessian(t, f, dummy, x));
         }
      }

      return Matrix<double>();
   }


   /// Returns the hessian matrix of a function of several dimensions using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_forward_differences_hessian(const T& t, double(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      const size_t n = x.size();

      Matrix<double> H(n, n);

      double h_i;
      double h_j;

      double y = (t.*f)(dummy, x);

      Vector<double> x_forward_2i(x);
      Vector<double> x_forward_ij(x);
      Vector<double> x_forward_i(x);
      Vector<double> x_forward_j(x);

      double y_forward_2i;
      double y_forward_ij;
      double y_forward_i;
      double y_forward_j;

      for(size_t i = 0; i < n; i++)
      {
         h_i = calculate_h(x[i]);

         x_forward_i[i] += h_i;       
         y_forward_i = (t.*f)(dummy, x_forward_i);
         x_forward_i[i] -= h_i;       

         x_forward_2i[i] += 2.0*h_i;       
         y_forward_2i = (t.*f)(dummy, x_forward_2i);
         x_forward_2i[i] -= 2.0*h_i;       

         H(i,i) = (y_forward_2i - 2*y_forward_i + y)/pow(h_i, 2);  

         for(size_t j = i; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_forward_j[j] += h_j;       
            y_forward_j = (t.*f)(dummy, x_forward_j);
            x_forward_j[j] -= h_j;       

            x_forward_ij[i] += h_i; 
            x_forward_ij[j] += h_j; 
            y_forward_ij = (t.*f)(dummy, x_forward_ij);   
            x_forward_ij[i] -= h_i; 
            x_forward_ij[j] -= h_j; 
            
            H(i,j) = (y_forward_ij - y_forward_i - y_forward_j + y)/(h_i*h_j);
         } 
      }

      for(size_t i = 0; i < n; i++)
      {
         for(size_t j = 0; j < i; j++)
         {
            H(i,j) = H(j,i);
         }
      }

      return(H);
   }


   // Matrix<double> calculate_central_differences_hessian(const T&, double(T::*f)(const size_t&, const Vector<double>&) const, const size_t&, const Vector<double>&) const method

   /// Returns the hessian matrix of a function of several dimensions using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_central_differences_hessian(const T& t, double(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      const size_t n = x.size();

      double y = (t.*f)(dummy, x);

      Matrix<double> H(n, n);

      double h_i;
      double h_j;

      Vector<double> x_backward_2i(x);
      Vector<double> x_backward_i(x);

      Vector<double> x_forward_i(x);
      Vector<double> x_forward_2i(x);      

      Vector<double> x_backward_ij(x);
	  Vector<double> x_forward_ij(x);

	  Vector<double> x_backward_i_forward_j(x);
      Vector<double> x_forward_i_backward_j(x);

      double y_backward_2i;
      double y_backward_i;

      double y_forward_i;
      double y_forward_2i;
   
      double y_backward_ij;
	  double y_forward_ij;

	  double y_backward_i_forward_j;
      double y_forward_i_backward_j;

      for(size_t i = 0; i < n; i++)
      {
         h_i = calculate_h(x[i]);

         x_backward_2i[i] -= 2.0*h_i; 
         y_backward_2i = (t.*f)(dummy, x_backward_2i);
         x_backward_2i[i] += 2.0*h_i; 

         x_backward_i[i] -= h_i; 
         y_backward_i = (t.*f)(dummy, x_backward_i);
         x_backward_i[i] += h_i; 

         x_forward_i[i] += h_i; 
         y_forward_i = (t.*f)(dummy, x_forward_i);
         x_forward_i[i] -= h_i; 

         x_forward_2i[i] += 2.0*h_i; 
         y_forward_2i = (t.*f)(dummy, x_forward_2i);
         x_forward_2i[i] -= 2.0*h_i; 

         H(i,i) = (-y_forward_2i + 16.0*y_forward_i -30.0*y + 16.0*y_backward_i - y_backward_2i)/(12.0*pow(h_i, 2));  

         for(size_t j = i; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_backward_ij[i] -= h_i;  
            x_backward_ij[j] -= h_j;  
            y_backward_ij = (t.*f)(dummy, x_backward_ij);   
            x_backward_ij[i] += h_i;  
            x_backward_ij[j] += h_j;  

            x_forward_ij[i] += h_i;  
            x_forward_ij[j] += h_j;  
            y_forward_ij = (t.*f)(dummy, x_forward_ij);   
            x_forward_ij[i] -= h_i;  
            x_forward_ij[j] -= h_j;  
            
            x_backward_i_forward_j[i] -= h_i;
            x_backward_i_forward_j[j] += h_j;
            y_backward_i_forward_j = (t.*f)(dummy, x_backward_i_forward_j);   
            x_backward_i_forward_j[i] += h_i;
            x_backward_i_forward_j[j] -= h_j;

			x_forward_i_backward_j[i] += h_i;
			x_forward_i_backward_j[j] -= h_j;
            y_forward_i_backward_j = (t.*f)(dummy, x_forward_i_backward_j);   
			x_forward_i_backward_j[i] -= h_i;
			x_forward_i_backward_j[j] += h_j;
 
            H(i,j) = (y_forward_ij - y_forward_i_backward_j - y_backward_i_forward_j + y_backward_ij)/(4.0*h_i*h_j);
         }
      }

      for(size_t i = 0; i < n; i++)
      {
         for(size_t j = 0; j < i; j++)
         {
            H(i,j) = H(j,i);
         }
      }

      return(H);
   }


   // Matrix<double> calculate_hessian(const T&, double(T::*f)(const size_t&, const Vector<double>&) const, const size_t&, const Vector<double>&) const method

   /// Returns the hessian matrix of a function of several dimensions according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is dummy, differentiation is performed with respect to the second vector argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_hessian(const T& t, double(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_hessian(t, f, dummy, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_hessian(t, f, dummy, x));
    	 }
      }

      return Matrix<double>();
   }


   // JACOBIAN METHODS

   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_forward_differences_Jacobian(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(x); 

      double h;

      const size_t n = x.size();
      size_t m = y.size();

      Vector<double> x_forward(x);
      Vector<double> y_forward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	   {
         h = calculate_h(x[j]);

         x_forward[j] += h;
         y_forward = (t.*f)(x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		  {
		     J(i,j) = (y_forward[i] - y[i])/h;
		  }
	  }

      return(J);
   }


   // Matrix<double> calculate_central_differences_Jacobian(const T&, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>&) const method

   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_central_differences_Jacobian(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(x); 

      double h;

      const size_t n = x.size();
      size_t m = y.size();

      Vector<double> x_forward(x);
      Vector<double> x_backward(x);

	  Vector<double> y_forward(n);
	  Vector<double> y_backward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	  {
         h = calculate_h(x[j]);

         x_backward[j] -= h;
         y_backward = (t.*f)(x_backward);   
         x_backward[j] += h;

         x_forward[j] += h;
         y_forward = (t.*f)(x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		 {
		    J(i,j) = (y_forward[i] - y_backward[i])/(2.0*h);
		 }
	  }

      return(J);
   }


   /// Returns the Jacobian matrix of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_Jacobian(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_Jacobian(t, f, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_Jacobian(t, f, x));
    	 }
      }

      return Matrix<double>();
   }


   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&, const Vector<double>&) const. 
   /// @param t  Object constructor containing the member method to differentiate.  
   /// @param f Pointer to the member method.
   /// @param dummy Dummy vector for the method prototype.
   /// @param x Input vector. 

   template<class T> 
   Matrix<double> calculate_forward_differences_Jacobian(const T& t, Vector<double>(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(dummy, x); 

      double h;

      const size_t n = x.size();
      size_t m = y.size();

      Vector<double> x_forward(x);
      Vector<double> y_forward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	   {
         h = calculate_h(x[j]);

         x_forward[j] += h;
         y_forward = (t.*f)(dummy, x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		  {
		     J(i,j) = (y_forward[i] - y[i])/h;
		  }
	  }

      return(J);
   }


   // Matrix<double> calculate_central_differences_Jacobian(const T&, Vector<double>(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>&, const Vector<double>&) const method

   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy vector for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_central_differences_Jacobian(const T& t, Vector<double>(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(dummy, x); 

      double h;

      const size_t n = x.size();
      size_t m = y.size();

      Vector<double> x_forward(x);
      Vector<double> x_backward(x);

	  Vector<double> y_forward(n);
	  Vector<double> y_backward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	  {
         h = calculate_h(x[j]);

         x_backward[j] -= h;
         y_backward = (t.*f)(dummy, x_backward);   
         x_backward[j] += h;

         x_forward[j] += h;
         y_forward = (t.*f)(dummy, x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		 {
		    J(i,j) = (y_forward[i] - y_backward[i])/(2.0*h);
		 }
	  }

      return(J);
   }


   /// Returns the Jacobian matrix of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&, const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy vector for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_Jacobian(const T& t, Vector<double>(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_Jacobian(t, f, dummy, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_Jacobian(t, f, dummy, x));
    	 }
      }

      return Matrix<double>();
   }


   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is dummy, differentiation is performed with respect to the second vector argument.  
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_forward_differences_Jacobian(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(dummy, x); 

      double h;

      const size_t n = x.size();
      size_t m = y.size();

      Vector<double> x_forward(x);
      Vector<double> y_forward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	  {
         h = calculate_h(x[j]);

         x_forward[j] += h;
         y_forward = (t.*f)(dummy, x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		 {
		    J(i,j) = (y_forward[i] - y[i])/h;
		 }
	  }

      return(J);
   }


   // Matrix<double> calculate_central_differences_Jacobian(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t&, const Vector<double>&) const

   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is dummy, differentiation is performed with respect to the second vector argument.  
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_central_differences_Jacobian(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(dummy, x); 

      double h;

      const size_t n = x.size();
      size_t m = y.size();

      Vector<double> x_forward(x);
      Vector<double> x_backward(x);

	  Vector<double> y_forward(n);
	  Vector<double> y_backward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	  {
         h = calculate_h(x[j]);

         x_backward[j] -= h;
         y_backward = (t.*f)(dummy, x_backward);   
         x_backward[j] += h;

         x_forward[j] += h;
         y_forward = (t.*f)(dummy, x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		 {
		    J(i,j) = (y_forward[i] - y_backward[i])/(2.0*h);
		 }
	  }

      return(J);
   }


   // Matrix<double> calculate_Jacobian(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t&, const Vector<double>&) const method

   /// Returns the Jacobian matrix of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&) const. 
   /// The first integer argument is dummy, differentiation is performed with respect to the second vector argument.  
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_Jacobian(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_Jacobian(t, f, dummy, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_Jacobian(t, f, dummy, x));
    	 }
      }

      return Matrix<double>();
   }


   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument.  
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_int: Dummy integer for the method prototype.
   /// @param dummy_vector: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_forward_differences_Jacobian
  (const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t& dummy_int, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(dummy_int, dummy_vector, x); 

      double h;

      const size_t n = x.size();
      size_t m = y.size();

      Vector<double> x_forward(x);
      Vector<double> y_forward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	  {
         h = calculate_h(x[j]);

         x_forward[j] += h;
         y_forward = (t.*f)(dummy_int, dummy_vector, x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		 {
		    J(i,j) = (y_forward[i] - y[i])/h;
		 }
	  }

      return(J);
   }


   // Matrix<double> calculate_central_differences_Jacobian(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t&, const Vector<double>&, const Vector<double>&) const method

   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument.  
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_int: Dummy integer for the method prototype.
   /// @param dummy_vector: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_central_differences_Jacobian
  (const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t& dummy_int, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {
      const size_t n = x.size();

      const Vector<double> y = (t.*f)(dummy_int, dummy_vector, x); 
      const size_t m = y.size();

      double h;

      Vector<double> x_forward(x);
      Vector<double> x_backward(x);

	  Vector<double> y_forward(n);
	  Vector<double> y_backward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	  {
         h = calculate_h(x[j]);

         x_backward[j] -= h;
         y_backward = (t.*f)(dummy_int, dummy_vector, x_backward);   
         x_backward[j] += h;

         x_forward[j] += h;
         y_forward = (t.*f)(dummy_int, dummy_vector, x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		 {
		    J(i,j) = (y_forward[i] - y_backward[i])/(2.0*h);
		 }
	  }

      return(J);
   }


   // Matrix<double> calculate_Jacobian(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t&, const Vector<double>&, const Vector<double>&) const method

   /// Returns the Jacobian matrix of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument.  
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_int: Dummy integer for the method prototype.
   /// @param dummy_vector: Dummy vector for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_Jacobian
  (const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t& dummy_int, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_Jacobian(t, f, dummy_int, dummy_vector, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_Jacobian(t, f, dummy_int, dummy_vector, x));
    	 }
      }

      return Matrix<double>();
   }


   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument.  
   /// @param t Object constructor containing the member method to differentiate.  
   /// @param f Pointer to the member method.
   /// @param dummy_int_1 Dummy integer for the method prototype.
   /// @param dummy_int_2 Dummy integer for the method prototype.
   /// @param x Input vector. 

   template<class T> 
   Matrix<double> calculate_forward_differences_Jacobian
  (const T& t, Vector<double>(T::*f)(const size_t&, const size_t&, const Vector<double>&) const, const size_t& dummy_int_1, const size_t& dummy_int_2, const Vector<double>& x) const
   {
      const Vector<double> y = (t.*f)(dummy_int_1, dummy_int_2, x); 

      const size_t n = x.size();
      const size_t m = y.size();

      double h;

      Vector<double> x_forward(x);
      Vector<double> y_forward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	  {
         h = calculate_h(x[j]);

         x_forward[j] += h;
         y_forward = (t.*f)(dummy_int_1, dummy_int_2, x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		 {
		    J(i,j) = (y_forward[i] - y[i])/h;
		 }
	  }

      return(J);
   }


   // Matrix<double> calculate_central_differences_Jacobian(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t&, const Vector<double>&, const Vector<double>&) const method

   /// Returns the Jacobian matrix of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument.  
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_int_1: Dummy integer for the method prototype.
   /// @param dummy_int_2: Dummy integer for the method prototype.
   /// @param x: Input vector. 

   template<class T> 
   Matrix<double> calculate_central_differences_Jacobian
  (const T& t, Vector<double>(T::*f)(const size_t&, const size_t&, const Vector<double>&) const, const size_t& dummy_int_1, const size_t& dummy_int_2, const Vector<double>& x) const
   {
      const Vector<double> y = (t.*f)(dummy_int_1, dummy_int_2, x); 

      const size_t n = x.size();
      const size_t m = y.size();

      double h;

      Vector<double> x_forward(x);
      Vector<double> x_backward(x);

	  Vector<double> y_forward(n);
	  Vector<double> y_backward(n);

      Matrix<double> J(m,n);

      for(size_t j = 0; j < n; j++)
	  {
         h = calculate_h(x[j]);

         x_backward[j] -= h;
         y_backward = (t.*f)(dummy_int_1, dummy_int_2, x_backward);   
         x_backward[j] += h;

         x_forward[j] += h;
         y_forward = (t.*f)(dummy_int_1, dummy_int_2, x_forward);   
         x_forward[j] -= h;
         
	     for(size_t i = 0; i < m; i++)
		 {
		    J(i,j) = (y_forward[i] - y_backward[i])/(2.0*h);
		 }
	  }

      return(J);
   }


   /// Returns the Jacobian matrix of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: double f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument.  
   /// @param t Object constructor containing the member method to differentiate.  
   /// @param f Pointer to the member method.
   /// @param dummy_int_1 Dummy integer for the method prototype.
   /// @param dummy_int_2 Dummy integer for the method prototype.
   /// @param x Input vector. 

   template<class T> 
   Matrix<double> calculate_Jacobian
  (const T& t, Vector<double>(T::*f)(const size_t&, const size_t&, const Vector<double>&) const, const size_t& dummy_int_1, const size_t& dummy_int_2, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_Jacobian(t, f, dummy_int_1, dummy_int_2, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_Jacobian(t, f, dummy_int_1, dummy_int_2, x));
    	 }
      }

      return Matrix<double>();
   }


   // HESSIAN FORM METHODS


   // Vector<Matrix<double>> calculate_forward_differences_hessian(const T&, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_forward_differences_hessian(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {      
      Vector<double> y = (t.*f)(x);   

      size_t s = y.size();
      const size_t n = x.size();

      double h_j;
      double h_k;

      Vector<double> x_forward_j(x);       
      Vector<double> x_forward_2j(x);       

      Vector<double> x_forward_k(x);       
      Vector<double> x_forward_jk(x);       

      Vector<double> y_forward_j(s);       
      Vector<double> y_forward_2j(s);       

      Vector<double> y_forward_k(s);       
      Vector<double> y_forward_jk(s);       

      Vector<Matrix<double>> H(s);

      for(size_t i = 0; i < s; i++)
      {
         H[i].set(n,n);

         for(size_t j = 0; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_forward_j[j] += h_j;       
            y_forward_j = (t.*f)(x_forward_j);
            x_forward_j[j] -= h_j;       

            x_forward_2j[j] += 2.0*h_j;       
            y_forward_2j = (t.*f)(x_forward_2j);
            x_forward_2j[j] -= 2.0*h_j;       

            H[i](j,j) = (y_forward_2j[i] - 2.0*y_forward_j[i] + y[i])/pow(h_j, 2);

            for(size_t k = j; k < n; k++)
			{
               h_k = calculate_h(x[k]);

               x_forward_k[k] += h_k;       
               y_forward_k = (t.*f)(x_forward_k);
               x_forward_k[k] -= h_k;       

               x_forward_jk[j] += h_j; 
               x_forward_jk[k] += h_k; 
               y_forward_jk = (t.*f)(x_forward_jk);   
               x_forward_jk[j] -= h_j; 
               x_forward_jk[k] -= h_k; 
            
               H[i](j,k) = (y_forward_jk[i] - y_forward_j[i] - y_forward_k[i] + y[i])/(h_j*h_k);
			}
		 }

         for(size_t j = 0; j < n; j++)
         {
            for(size_t k = 0; k < j; k++)
            {
               H[i](j,k) = H[i](k,j);
            }
         }
      }

      return(H);
   }


   // Vector<Matrix<double>> calculate_central_differences_hessian(const T&, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_central_differences_hessian(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(x);   

      size_t s = y.size();
      const size_t n = x.size();

      double h_j;
      double h_k;

      Vector<double> x_backward_2j(x);
      Vector<double> x_backward_j(x);

      Vector<double> x_forward_j(x);
      Vector<double> x_forward_2j(x);      

      Vector<double> x_backward_jk(x);
	  Vector<double> x_forward_jk(x);

	  Vector<double> x_backward_j_forward_k(x);
      Vector<double> x_forward_j_backward_k(x);

      Vector<double> y_backward_2j;
      Vector<double> y_backward_j;

      Vector<double> y_forward_j;
      Vector<double> y_forward_2j;
   
      Vector<double> y_backward_jk;
	  Vector<double> y_forward_jk;

	  Vector<double> y_backward_j_forward_k;
      Vector<double> y_forward_j_backward_k;

      Vector<Matrix<double>> H(s);

      for(size_t i = 0; i < s; i++)
	  {
         H[i].set(n,n);

      	 for(size_t j = 0; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_backward_2j[j] -= 2.0*h_j; 
            y_backward_2j = (t.*f)(x_backward_2j);
            x_backward_2j[j] += 2.0*h_j; 

            x_backward_j[j] -= h_j; 
            y_backward_j = (t.*f)(x_backward_j);
            x_backward_j[j] += h_j; 

            x_forward_j[j] += h_j; 
            y_forward_j = (t.*f)(x_forward_j);
            x_forward_j[j] -= h_j; 

            x_forward_2j[j] += 2.0*h_j; 
            y_forward_2j = (t.*f)(x_forward_2j);
            x_forward_2j[j] -= 2.0*h_j; 

            H[i](j,j) = (-y_forward_2j[i] + 16.0*y_forward_j[i] -30.0*y[i] + 16.0*y_backward_j[i] - y_backward_2j[i])/(12.0*pow(h_j, 2));

            for(size_t k = j; k < n; k++)
            {
               h_k = calculate_h(x[k]);

               x_backward_jk[j] -= h_j;  
               x_backward_jk[k] -= h_k;  
               y_backward_jk = (t.*f)(x_backward_jk);   
               x_backward_jk[j] += h_j;  
               x_backward_jk[k] += h_k;  

               x_forward_jk[j] += h_j;  
               x_forward_jk[k] += h_k;  
               y_forward_jk = (t.*f)(x_forward_jk);   
               x_forward_jk[j] -= h_j;  
               x_forward_jk[k] -= h_k;  
            
               x_backward_j_forward_k[j] -= h_j;
               x_backward_j_forward_k[k] += h_k;
               y_backward_j_forward_k = (t.*f)(x_backward_j_forward_k);   
               x_backward_j_forward_k[j] += h_j;
               x_backward_j_forward_k[k] -= h_k;

			   x_forward_j_backward_k[j] += h_j;
			   x_forward_j_backward_k[k] -= h_k;
               y_forward_j_backward_k = (t.*f)(x_forward_j_backward_k);   
			   x_forward_j_backward_k[j] -= h_j;
			   x_forward_j_backward_k[k] += h_k;
 
               H[i](j,k) = (y_forward_jk[i] - y_forward_j_backward_k[i] - y_backward_j_forward_k[i] + y_backward_jk[i])/(4.0*h_j*h_k);
            }
         }
	  
         for(size_t j = 0; j < n; j++)
         {
            for(size_t k = 0; k < j; k++)
            {
               H[i](j,k) = H[i](k,j);
            }
         }
	  }

      return(H);
   }


   // Vector<Matrix<double>> calculate_hessian(const T&, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: Vector<double> f(const Vector<double>&) const. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_hessian(const T& t, Vector<double>(T::*f)(const Vector<double>&) const, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_hessian(t, f, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_hessian(t, f, x));
         }
      }

      return Vector<Matrix<double>>();
   }


   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_vector: Dummy vector for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_forward_differences_hessian
  (const T& t, Vector<double>(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {      
      Vector<double> y = (t.*f)(dummy_vector, x);   

      size_t s = y.size();
      const size_t n = x.size();

      double h_j;
      double h_k;

      Vector<double> x_forward_j(x);       
      Vector<double> x_forward_2j(x);       

      Vector<double> x_forward_k(x);       
      Vector<double> x_forward_jk(x);       

      Vector<double> y_forward_j(s);       
      Vector<double> y_forward_2j(s);       

      Vector<double> y_forward_k(s);       
      Vector<double> y_forward_jk(s);       

      Vector<Matrix<double>> H(s);

      for(size_t i = 0; i < s; i++)
      {
         H[i].set(n,n);

         for(size_t j = 0; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_forward_j[j] += h_j;       
            y_forward_j = (t.*f)(dummy_vector, x_forward_j);
            x_forward_j[j] -= h_j;       

            x_forward_2j[j] += 2.0*h_j;       
            y_forward_2j = (t.*f)(dummy_vector, x_forward_2j);
            x_forward_2j[j] -= 2.0*h_j;       

            H[i](j,j) = (y_forward_2j[i] - 2.0*y_forward_j[i] + y[i])/pow(h_j, 2);

	        for(size_t k = j; k < n; k++)
		    {
               h_k = calculate_h(x[k]);

               x_forward_k[k] += h_k;       
               y_forward_k = (t.*f)(dummy_vector, x_forward_k);
               x_forward_k[k] -= h_k;       

               x_forward_jk[j] += h_j; 
               x_forward_jk[k] += h_k; 
               y_forward_jk = (t.*f)(dummy_vector, x_forward_jk);   
               x_forward_jk[j] -= h_j; 
               x_forward_jk[k] -= h_k; 
            
               H[i](j,k) = (y_forward_jk[i] - y_forward_j[i] - y_forward_k[i] + y[i])/(h_j*h_k);
			}
		 }

         for(size_t j = 0; j < n; j++)
         {
            for(size_t k = 0; k < j; k++)
            {
               H[i](j,k) = H[i](k,j);
            }
         }
      }

      return(H);
   }


   // Vector<Matrix<double>> calculate_central_differences_hessian
   //(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const Vector<double>&, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_vector: Dummy vector for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_central_differences_hessian
  (const T& t, Vector<double>(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(dummy_vector, x);   

      size_t s = y.size();
      const size_t n = x.size();

      double h_j;
      double h_k;

      Vector<double> x_backward_2j(x);
      Vector<double> x_backward_j(x);

      Vector<double> x_forward_j(x);
      Vector<double> x_forward_2j(x);      

      Vector<double> x_backward_jk(x);
      Vector<double> x_forward_jk(x);

	  Vector<double> x_backward_j_forward_k(x);
      Vector<double> x_forward_j_backward_k(x);

      Vector<double> y_backward_2j;
      Vector<double> y_backward_j;

      Vector<double> y_forward_j;
      Vector<double> y_forward_2j;
   
      Vector<double> y_backward_jk;
	  Vector<double> y_forward_jk;

	  Vector<double> y_backward_j_forward_k;
      Vector<double> y_forward_j_backward_k;

      Vector<Matrix<double>> H(s);

      for(size_t i = 0; i < s; i++)
	  {
         H[i].set(n,n);

      	 for(size_t j = 0; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_backward_2j[j] -= 2.0*h_j; 
            y_backward_2j = (t.*f)(dummy_vector, x_backward_2j);
            x_backward_2j[j] += 2.0*h_j; 

            x_backward_j[j] -= h_j; 
            y_backward_j = (t.*f)(dummy_vector, x_backward_j);
            x_backward_j[j] += h_j; 

            x_forward_j[j] += h_j; 
            y_forward_j = (t.*f)(dummy_vector, x_forward_j);
            x_forward_j[j] -= h_j; 

            x_forward_2j[j] += 2.0*h_j; 
            y_forward_2j = (t.*f)(dummy_vector, x_forward_2j);
            x_forward_2j[j] -= 2.0*h_j; 

            H[i](j,j) = (-y_forward_2j[i] + 16.0*y_forward_j[i] -30.0*y[i] + 16.0*y_backward_j[i] - y_backward_2j[i])/(12.0*pow(h_j, 2));

            for(size_t k = j; k < n; k++)
            {
               h_k = calculate_h(x[k]);

               x_backward_jk[j] -= h_j;  
               x_backward_jk[k] -= h_k;  
               y_backward_jk = (t.*f)(dummy_vector, x_backward_jk);   
               x_backward_jk[j] += h_j;  
               x_backward_jk[k] += h_k;  

               x_forward_jk[j] += h_j;  
               x_forward_jk[k] += h_k;  
               y_forward_jk = (t.*f)(dummy_vector, x_forward_jk);   
               x_forward_jk[j] -= h_j;  
               x_forward_jk[k] -= h_k;  
            
               x_backward_j_forward_k[j] -= h_j;
               x_backward_j_forward_k[k] += h_k;
               y_backward_j_forward_k = (t.*f)(dummy_vector, x_backward_j_forward_k);   
               x_backward_j_forward_k[j] += h_j;
               x_backward_j_forward_k[k] -= h_k;

			   x_forward_j_backward_k[j] += h_j;
			   x_forward_j_backward_k[k] -= h_k;
               y_forward_j_backward_k = (t.*f)(dummy_vector, x_forward_j_backward_k);   
			   x_forward_j_backward_k[j] -= h_j;
			   x_forward_j_backward_k[k] += h_k;
 
               H[i](j,k) = (y_forward_jk[i] - y_forward_j_backward_k[i] - y_backward_j_forward_k[i] + y_backward_jk[i])/(4.0*h_j*h_k);
            }
         }
	  
         for(size_t j = 0; j < n; j++)
         {
            for(size_t k = 0; k < j; k++)
            {
               H[i](j,k) = H[i](k,j);
            }
         }
	  }

      return(H);
   }


   // Vector<Matrix<double>> calculate_hessian
   //(const T& t, Vector<double>(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>&, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_vector: Dummy vector for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_hessian
  (const T& t, Vector<double>(T::*f)(const Vector<double>&, const Vector<double>&) const, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_hessian(t, f, dummy_vector, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_hessian(t, f, dummy_vector, x));
    	 }
      }

      return Vector<Matrix<double>>();
   }


   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// The first argument is dummy, differentiation is performed with respect to the second argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_forward_differences_hessian(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {      
      Vector<double> y = (t.*f)(dummy, x);   

      size_t s = y.size();
      const size_t n = x.size();

      double h_j;
      double h_k;

      Vector<double> x_forward_j(x);       
      Vector<double> x_forward_2j(x);       

      Vector<double> x_forward_k(x);       
      Vector<double> x_forward_jk(x);       

      Vector<double> y_forward_j(s);       
      Vector<double> y_forward_2j(s);       

      Vector<double> y_forward_k(s);       
      Vector<double> y_forward_jk(s);       

      Vector<Matrix<double>> H(s);

      for(size_t i = 0; i < s; i++)
      {
         H[i].set(n,n);

         for(size_t j = 0; j < n; j++)
		   {
            h_j = calculate_h(x[j]);

            x_forward_j[j] += h_j;       
            y_forward_j = (t.*f)(dummy, x_forward_j);
            x_forward_j[j] -= h_j;       

            x_forward_2j[j] += 2.0*h_j;       
            y_forward_2j = (t.*f)(dummy, x_forward_2j);
            x_forward_2j[j] -= 2.0*h_j;       

            H[i](j,j) = (y_forward_2j[i] - 2.0*y_forward_j[i] + y[i])/pow(h_j, 2);

	         for(size_t k = j; k < n; k++)
			   {
               h_k = calculate_h(x[k]);

               x_forward_k[k] += h_k;       
               y_forward_k = (t.*f)(dummy, x_forward_k);
               x_forward_k[k] -= h_k;       

               x_forward_jk[j] += h_j; 
               x_forward_jk[k] += h_k; 
               y_forward_jk = (t.*f)(dummy, x_forward_jk);   
               x_forward_jk[j] -= h_j; 
               x_forward_jk[k] -= h_k; 
            
               H[i](j,k) = (y_forward_jk[i] - y_forward_j[i] - y_forward_k[i] + y[i])/(h_j*h_k);
            }
		 }

         for(size_t j = 0; j < n; j++)
         {
            for(size_t k = 0; k < j; k++)
            {
               H[i](j,k) = H[i](k,j);
            }
         }
      }

      return(H);
   }


   // Vector<Matrix<double>> calculate_central_differences_hessian(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t&, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// The first argument is dummy, differentiation is performed with respect to the second argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_central_differences_hessian(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      Vector<double> y = (t.*f)(dummy, x);   

      size_t s = y.size();
      const size_t n = x.size();

      double h_j;
      double h_k;

      Vector<double> x_backward_2j(x);
      Vector<double> x_backward_j(x);

      Vector<double> x_forward_j(x);
      Vector<double> x_forward_2j(x);      

      Vector<double> x_backward_jk(x);
      Vector<double> x_forward_jk(x);

	  Vector<double> x_backward_j_forward_k(x);
      Vector<double> x_forward_j_backward_k(x);

      Vector<double> y_backward_2j;
      Vector<double> y_backward_j;

      Vector<double> y_forward_j;
      Vector<double> y_forward_2j;
   
      Vector<double> y_backward_jk;
	  Vector<double> y_forward_jk;

	  Vector<double> y_backward_j_forward_k;
      Vector<double> y_forward_j_backward_k;

      Vector<Matrix<double>> H(s);

      for(size_t i = 0; i < s; i++)
	  {
         H[i].set(n,n);

      	 for(size_t j = 0; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_backward_2j[j] -= 2.0*h_j; 
            y_backward_2j = (t.*f)(dummy, x_backward_2j);
            x_backward_2j[j] += 2.0*h_j; 

            x_backward_j[j] -= h_j; 
            y_backward_j = (t.*f)(dummy, x_backward_j);
            x_backward_j[j] += h_j; 

            x_forward_j[j] += h_j; 
            y_forward_j = (t.*f)(dummy, x_forward_j);
            x_forward_j[j] -= h_j; 

            x_forward_2j[j] += 2.0*h_j; 
            y_forward_2j = (t.*f)(dummy, x_forward_2j);
            x_forward_2j[j] -= 2.0*h_j; 

            H[i](j,j) = (-y_forward_2j[i] + 16.0*y_forward_j[i] -30.0*y[i] + 16.0*y_backward_j[i] - y_backward_2j[i])/(12.0*pow(h_j, 2));

            for(size_t k = j; k < n; k++)
            {
               h_k = calculate_h(x[k]);

               x_backward_jk[j] -= h_j;  
               x_backward_jk[k] -= h_k;  
               y_backward_jk = (t.*f)(dummy, x_backward_jk);   
               x_backward_jk[j] += h_j;  
               x_backward_jk[k] += h_k;  

               x_forward_jk[j] += h_j;  
               x_forward_jk[k] += h_k;  
               y_forward_jk = (t.*f)(dummy, x_forward_jk);   
               x_forward_jk[j] -= h_j;  
               x_forward_jk[k] -= h_k;  
            
               x_backward_j_forward_k[j] -= h_j;
               x_backward_j_forward_k[k] += h_k;
               y_backward_j_forward_k = (t.*f)(dummy, x_backward_j_forward_k);   
               x_backward_j_forward_k[j] += h_j;
               x_backward_j_forward_k[k] -= h_k;

			   x_forward_j_backward_k[j] += h_j;
			   x_forward_j_backward_k[k] -= h_k;
               y_forward_j_backward_k = (t.*f)(dummy, x_forward_j_backward_k);   
			   x_forward_j_backward_k[j] -= h_j;
			   x_forward_j_backward_k[k] += h_k;
 
               H[i](j,k) = (y_forward_jk[i] - y_forward_j_backward_k[i] - y_backward_j_forward_k[i] + y_backward_jk[i])/(4.0*h_j*h_k);
            }
         }
	  
         for(size_t j = 0; j < n; j++)
         {
            for(size_t k = 0; k < j; k++)
            {
               H[i](j,k) = H[i](k,j);
            }
         }
	  }

      return(H);
   }


   // Vector<Matrix<double>> calculate_hessian(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t&, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&) const. 
   /// The first argument is dummy, differentiation is performed with respect to the second argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy: Dummy integer for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_hessian(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&) const, const size_t& dummy, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_hessian(t, f, dummy, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_hessian(t, f, dummy, x));
    	 }
      }

      return Vector<Matrix<double>>();
   }


   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs using the forward differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_int: Dummy integer for the method prototype. 
   /// @param dummy_vector: Dummy vector for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_forward_differences_hessian
  (const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t& dummy_int, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {      
      Vector<double> y = (t.*f)(dummy_int, dummy_vector, x);   

      size_t s = y.size();
      const size_t n = x.size();

      double h_j;
      double h_k;

      Vector<double> x_forward_j(x);       
      Vector<double> x_forward_2j(x);       

      Vector<double> x_forward_k(x);       
      Vector<double> x_forward_jk(x);       

      Vector<double> y_forward_j(s);       
      Vector<double> y_forward_2j(s);       

      Vector<double> y_forward_k(s);       
      Vector<double> y_forward_jk(s);       

      Vector<Matrix<double>> H(s);

      for(size_t i = 0; i < s; i++)
      {
         H[i].set(n,n);

         for(size_t j = 0; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_forward_j[j] += h_j;       
            y_forward_j = (t.*f)(dummy_int, dummy_vector, x_forward_j);
            x_forward_j[j] -= h_j;       

            x_forward_2j[j] += 2.0*h_j;       
            y_forward_2j = (t.*f)(dummy_int, dummy_vector, x_forward_2j);
            x_forward_2j[j] -= 2.0*h_j;       

            H[i](j,j) = (y_forward_2j[i] - 2.0*y_forward_j[i] + y[i])/pow(h_j, 2);

	        for(size_t k = j; k < n; k++)
		    {
               h_k = calculate_h(x[k]);

               x_forward_k[k] += h_k;       
               y_forward_k = (t.*f)(dummy_int, dummy_vector, x_forward_k);
               x_forward_k[k] -= h_k;       

               x_forward_jk[j] += h_j; 
               x_forward_jk[k] += h_k; 
               y_forward_jk = (t.*f)(dummy_int, dummy_vector, x_forward_jk);   
               x_forward_jk[j] -= h_j; 
               x_forward_jk[k] -= h_k; 
            
               H[i](j,k) = (y_forward_jk[i] - y_forward_j[i] - y_forward_k[i] + y[i])/(h_j*h_k);
			}
		 }

         for(size_t j = 0; j < n; j++)
         {
            for(size_t k = 0; k < j; k++)
            {
               H[i](j,k) = H[i](k,j);
            }
         }
      }

      return(H);
   }


   // Vector<Matrix<double>> calculate_central_differences_hessian
   //(const T&, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t&, const Vector<double>&, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs using the central differences method. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_int: Dummy integer for the method prototype. 
   /// @param dummy_vector: Dummy vector for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_central_differences_hessian
  (const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t& dummy_int, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {
      const Vector<double> y = (t.*f)(dummy_int, dummy_vector, x);   

      size_t s = y.size();
      const size_t n = x.size();

      double h_j;
      double h_k;

      Vector<double> x_backward_2j(x);
      Vector<double> x_backward_j(x);

      Vector<double> x_forward_j(x);
      Vector<double> x_forward_2j(x);      

      Vector<double> x_backward_jk(x);
      Vector<double> x_forward_jk(x);

	  Vector<double> x_backward_j_forward_k(x);
      Vector<double> x_forward_j_backward_k(x);

      Vector<double> y_backward_2j;
      Vector<double> y_backward_j;

      Vector<double> y_forward_j;
      Vector<double> y_forward_2j;
   
      Vector<double> y_backward_jk;
	  Vector<double> y_forward_jk;

	  Vector<double> y_backward_j_forward_k;
      Vector<double> y_forward_j_backward_k;

      Vector<Matrix<double>> H(s);

      for(size_t i = 0; i < s; i++)
	  {
         H[i].set(n,n);

      	 for(size_t j = 0; j < n; j++)
         {
            h_j = calculate_h(x[j]);

            x_backward_2j[j] -= 2.0*h_j; 
            y_backward_2j = (t.*f)(dummy_int, dummy_vector, x_backward_2j);
            x_backward_2j[j] += 2.0*h_j; 

            x_backward_j[j] -= h_j; 
            y_backward_j = (t.*f)(dummy_int, dummy_vector, x_backward_j);
            x_backward_j[j] += h_j; 

            x_forward_j[j] += h_j; 
            y_forward_j = (t.*f)(dummy_int, dummy_vector, x_forward_j);
            x_forward_j[j] -= h_j; 

            x_forward_2j[j] += 2.0*h_j; 
            y_forward_2j = (t.*f)(dummy_int, dummy_vector, x_forward_2j);
            x_forward_2j[j] -= 2.0*h_j; 

            H[i](j,j) = (-y_forward_2j[i] + 16.0*y_forward_j[i] -30.0*y[i] + 16.0*y_backward_j[i] - y_backward_2j[i])/(12.0*pow(h_j, 2));

            for(size_t k = j; k < n; k++)
            {
               h_k = calculate_h(x[k]);

               x_backward_jk[j] -= h_j;  
               x_backward_jk[k] -= h_k;  
               y_backward_jk = (t.*f)(dummy_int, dummy_vector, x_backward_jk);   
               x_backward_jk[j] += h_j;  
               x_backward_jk[k] += h_k;  

               x_forward_jk[j] += h_j;  
               x_forward_jk[k] += h_k;  
               y_forward_jk = (t.*f)(dummy_int, dummy_vector, x_forward_jk);   
               x_forward_jk[j] -= h_j;  
               x_forward_jk[k] -= h_k;  
            
               x_backward_j_forward_k[j] -= h_j;
               x_backward_j_forward_k[k] += h_k;
               y_backward_j_forward_k = (t.*f)(dummy_int, dummy_vector, x_backward_j_forward_k);   
               x_backward_j_forward_k[j] += h_j;
               x_backward_j_forward_k[k] -= h_k;

			   x_forward_j_backward_k[j] += h_j;
			   x_forward_j_backward_k[k] -= h_k;
               y_forward_j_backward_k = (t.*f)(dummy_int, dummy_vector, x_forward_j_backward_k);   
			   x_forward_j_backward_k[j] -= h_j;
			   x_forward_j_backward_k[k] += h_k;
 
               H[i](j,k) = (y_forward_jk[i] - y_forward_j_backward_k[i] - y_backward_j_forward_k[i] + y_backward_jk[i])/(4.0*h_j*h_k);
            }
         }
	  
         for(size_t j = 0; j < n; j++)
         {
            for(size_t k = 0; k < j; k++)
            {
               H[i](j,k) = H[i](k,j);
            }
         }
	  }

      return(H);
   }


   // Vector<Matrix<double>> calculate_hessian
   //(const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t&, const Vector<double>&, const Vector<double>&) const method

   /// Returns the hessian form, as a vector of matrices, of a function of many inputs and many outputs according to the numerical differentiation method to be used. 
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&, const Vector<double>&) const. 
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument. 
   /// @param t : Object constructor containing the member method to differentiate.  
   /// @param f: Pointer to the member method.
   /// @param dummy_int: Dummy integer for the method prototype. 
   /// @param dummy_vector: Dummy vector for the method prototype. 
   /// @param x: Input vector. 

   template<class T> 
   Vector<Matrix<double>> calculate_hessian
  (const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t& dummy_int, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {
      switch(numerical_differentiation_method)
      {
         case ForwardDifferences:
         {
            return(calculate_forward_differences_hessian(t, f, dummy_int, dummy_vector, x));
      	 }

         case CentralDifferences:
         {
            return(calculate_central_differences_hessian(t, f, dummy_int, dummy_vector, x));
    	 }   	         
      }

      return Vector<Matrix<double>>();
   }


   /// Returns the hessian matrices, as a matrix of matrices, of a function of many inputs and many outputs using the central differences method.
   /// The function to be differentiated is of the following form: Vector<double> f(const size_t&, const Vector<double>&, const Vector<double>&) const.
   /// The first and second arguments are dummy, differentiation is performed with respect to the third argument.
   /// @param t : Object constructor containing the member method to differentiate.
   /// @param f: Pointer to the member method.
   /// @param dummy_int: Dummy integer for the method prototype.
   /// @param dummy_vector: Dummy vector for the method prototype.
   /// @param x: Input vector.

   template<class T>
   Matrix< Matrix<double> > calculate_central_differences_hessian_matrices
  (const T& t, Vector<double>(T::*f)(const size_t&, const Vector<double>&, const Vector<double>&) const, const size_t& dummy_int, const Vector<double>& dummy_vector, const Vector<double>& x) const
   {
       const Vector<double> y = (t.*f)(dummy_int, dummy_vector, x);

       size_t s = y.size();
       const size_t n = x.size();

       double h_j;
       double h_k;

       Vector<double> x_backward_2j(x);
       Vector<double> x_backward_j(x);

       Vector<double> x_forward_j(x);
       Vector<double> x_forward_2j(x);

       Vector<double> x_backward_jk(x);
       Vector<double> x_forward_jk(x);

       Vector<double> x_backward_j_forward_k(x);
       Vector<double> x_forward_j_backward_k(x);

       Vector<double> y_backward_2j;
       Vector<double> y_backward_j;

       Vector<double> y_forward_j;
       Vector<double> y_forward_2j;

       Vector<double> y_backward_jk;
       Vector<double> y_forward_jk;

       Vector<double> y_backward_j_forward_k;
       Vector<double> y_forward_j_backward_k;

       Matrix< Matrix<double> > H;

       H.set(n,s);

       for(size_t i = 0; i < s; i++)
       {
           for(size_t t = 0; t < n; t++)
           {
               H(i,t).set(n,s);

               for(size_t j = 0; j < n; j++)
               {
                   h_j = calculate_h(x[j]);

                   x_backward_2j[j] -= 2.0*h_j;
                   y_backward_2j = (t.*f)(dummy_int, dummy_vector, x_backward_2j);
                   x_backward_2j[j] += 2.0*h_j;

                   x_backward_j[j] -= h_j;
                   y_backward_j = (t.*f)(dummy_int, dummy_vector, x_backward_j);
                   x_backward_j[j] += h_j;

                   x_forward_j[j] += h_j;
                   y_forward_j = (t.*f)(dummy_int, dummy_vector, x_forward_j);
                   x_forward_j[j] -= h_j;

                   x_forward_2j[j] += 2.0*h_j;
                   y_forward_2j = (t.*f)(dummy_int, dummy_vector, x_forward_2j);
                   x_forward_2j[j] -= 2.0*h_j;

                   H[i](j,j) = (-y_forward_2j[i] + 16.0*y_forward_j[i] -30.0*y[i] + 16.0*y_backward_j[i] - y_backward_2j[i])/(12.0*pow(h_j, 2));

                   for(size_t k = j; k < s; k++)
                   {
                       h_k = calculate_h(x[k]);

                       x_backward_jk[j] -= h_j;
                       x_backward_jk[k] -= h_k;
                       y_backward_jk = (t.*f)(dummy_int, dummy_vector, x_backward_jk);
                       x_backward_jk[j] += h_j;
                       x_backward_jk[k] += h_k;

                       x_forward_jk[j] += h_j;
                       x_forward_jk[k] += h_k;
                       y_forward_jk = (t.*f)(dummy_int, dummy_vector, x_forward_jk);
                       x_forward_jk[j] -= h_j;
                       x_forward_jk[k] -= h_k;

                       x_backward_j_forward_k[j] -= h_j;
                       x_backward_j_forward_k[k] += h_k;
                       y_backward_j_forward_k = (t.*f)(dummy_int, dummy_vector, x_backward_j_forward_k);
                       x_backward_j_forward_k[j] += h_j;
                       x_backward_j_forward_k[k] -= h_k;

                       x_forward_j_backward_k[j] += h_j;
                       x_forward_j_backward_k[k] -= h_k;
                       y_forward_j_backward_k = (t.*f)(dummy_int, dummy_vector, x_forward_j_backward_k);
                       x_forward_j_backward_k[j] -= h_j;
                       x_forward_j_backward_k[k] += h_k;

                       H(i,t)(j,k) = (y_forward_jk[i] - y_forward_j_backward_k[i] - y_backward_j_forward_k[i] + y_backward_jk[i])/(4.0*h_j*h_k);
                   }
               }

               for(size_t j = 0; j < n; j++)
               {
                   for(size_t k = 0; k < j; k++)
                   {
                       H(i,t)(j,k) = H[i](k,j);
                   }
               }
           }
       }

       return(H);
   }


private:

   /// Numerical differentiation method variable. 

   NumericalDifferentiationMethod numerical_differentiation_method;

   /// Number of precision digits. 

   size_t precision_digits;

   /// Flag for displaying warning messages from this class. 

   bool display;

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

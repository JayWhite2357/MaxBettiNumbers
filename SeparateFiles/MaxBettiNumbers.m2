-- -*- coding: utf-8 -*-
newPackage( "MaxBettiNumbers",
  Headline =>
  "Methods to find Maximum Betti numbers given bounds on the Hilbert function",
  Version => "0.9",
  Date => "July 14, 2020",
  Authors => { { Name => "Jay White", Email => "jay.white@uky.edu" } },
  DebuggingMode => true,
  HomePage => "https://github.com/JayWhite2357/maxbetti"
);

--------------------------------------------------------------------------------
--- exports
--------------------------------------------------------------------------------

--- exports and options for the main method of the package, maxBettiNumbers
export { "maxBettiNumbers" };
export { "HilbertFunctionLowerBound", "HilbertDifferenceLowerBound" };
export { "HilbertFunctionUpperBound", "HilbertDifferenceUpperBound" };
export { "HilbertPolynomial", "ResultsCount" };
--export { "Algorithm" };

--- exports for the type, MaxBetti, that is returned by maxBettiNumbers
export { "MaxBetti" };
export { "isRealizable", "BettiUpperBound", "MaximumBettiSum" };
export { "HilbertFunctions", "MaximalBettiNumbers" };

--- exports and options for the auxillary methods of the package
export { "lexBetti", "almostLexBetti" };
export { "lexsegmentIdeal", "almostLexIdeal" };
export { "AsTally" };

--------------------------------------------------------------------------------
--- end exports
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- types
--------------------------------------------------------------------------------

load "MaxType.m2"

--------------------------------------------------------------------------------
--- end types
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- Functions to deal with the Macaulay Representation of a Number
--------------------------------------------------------------------------------

load "mRep.m2"

--------------------------------------------------------------------------------
--- End Macaulay Representation Methods
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Beginning of functions to Sanitize and Optimize the inputs -----------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

load "SanitizeInputs.m2"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- End Sanitize and Optimize --------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- Functions to build V and lowerBound for use in the algorithms.
--------------------------------------------------------------------------------

load "BuildVlb.m2"

--------------------------------------------------------------------------------
--- End functions for building V and lowerBound
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Begining of the driver methods of the Algorithms themselves ----------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

load "AllAlgorithms.m2"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- End of the main algorithm code ---------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- functions for extracting hilbert function from the algorithm's return value
--------------------------------------------------------------------------------

load "UnravelHFs.m2"

--------------------------------------------------------------------------------
--- End unravel functions
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- auxillary methods
--------------------------------------------------------------------------------

load "lexBetti.m2"

--------------------------------------------------------------------------------
--- end auxillary methods
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- main Method that parses options and delegates to the appropriate algorithm
--------------------------------------------------------------------------------

load "MainMethod.m2"

--------------------------------------------------------------------------------
--- end main Method
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Beginning of documentation -------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

beginDocumentation( )

load "documentation.m2"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- End of documentation -------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Beginning of tests ---------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

load "tests.m2"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- End of tests ---------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


end

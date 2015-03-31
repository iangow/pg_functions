-- Function to determine which version of Python is running.
CREATE OR REPLACE FUNCTION which_python() RETURNS text AS 
$BODY$
    """ Function to determine which version of Python  
        is being seen by PostgreSQL.
    """    
    import sys
    return sys.version
$BODY$ LANGUAGE plpythonu;

SELECT which_python();

CREATE OR REPLACE FUNCTION r_sum(x double precision[])
  RETURNS double precision AS
$BODY$
    sum(x, na.rm=TRUE) 
$BODY$
  LANGUAGE plr;

CREATE OR REPLACE FUNCTION row_sum (VARIADIC anyarray) RETURNS float8 AS $$
    SELECT r_sum(ARRAY[$1]) 
$$ LANGUAGE  sql ;-- 
-- 
-- CREATE OR REPLACE FUNCTION row_sum_alt(VARIADIC x double precision[])
--   RETURNS double precision AS
-- $BODY$
--     sum(x, na.rm=TRUE) 
-- $BODY$
--   LANGUAGE plr ;
-- 
-- 
-- 
WITh data AS (
  SELECT bidlo, askhi, abs(prc) AS prc, bid
  FROM crsp.dsf
  LIMIT 10)
SELECT *, row_sum(bidlo, askhi, prc)
FROm data;

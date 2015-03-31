DROP TABLE IF EXISTS test_data;

CREATE TABLE test_data (
  fyear integer,
  eps float8
);

INSERT INTO test_data
SELECT CASE WHEN b.f % 2 = 0 THEN 1950 ELSE 1951 END AS fyear,
       f::float8/10000 AS eps
FROM generate_series(-5000,4999,1) b(f);

SELECT fyear, eps, ntile(5) OVER (PARTITION BY fyear ORDER BY eps) AS
eps_r FROM test_data ORDER BY fyear, eps;

CREATE OR REPLACE FUNCTION twin(anyelement)
RETURNS anyelement AS $$
as.integer(cut(arg1,as.vector(quantile(farg1,probs=seq(0,1,length.out=6),na.rm=TRUE)),
include.lowest=TRUE))
$$ LANGUAGE 'plr' WINDOW;

SELECT fyear, eps,
        twin(eps) OVER w AS eps_r
FROM test_data
WINDOW w AS
(
   PARTITION BY fyear
   ORDER BY fyear, eps
   ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
)
ORDER BY fyear, eps;

SELECT median(eps) FROM test_data;

DROP FUNCTION IF EXISTS evol(anyelement, anyelement) CASCADE;

CREATE OR REPLACE FUNCTION evol(anyelement, anyelement)
RETURNS anyelement AS
$BODY$
vol <- NA
if ( length(farg1) == 9) {
x <- farg1 + rnorm(9)
y <- farg1
reg.data <- data.frame(y=y, x=x)
try ({
vol <- var(resid(lm(y ~ x, data=reg.data, na.action=na.exclude)))
}, silent=TRUE)
}
return(arg2)
$BODY$
LANGUAGE plr WINDOW;

SELECT *, evol(eps, lag_eps) OVER w AS evol
FROM (SELECT fyear, eps,
lag(eps) OVER (ORDER BY fyear) AS lag_eps
FROM test_data) AS a
WHERE eps IS NOT NULL
WINDOW w AS (ORDER BY fyear ROWS 8 PRECEDING);

SELECT median(eps) FROM test_data;
-- 85 ms
SELECT DISTINCT fyear, median(eps) OVER (PARTITION BY fyear) FROM test_data ORDER BY fyear;
-- 48 ms

SELECT DISTINCT eps, median(fyear) OVER (PARTITION BY eps) FROM test_data ORDER BY eps;
-- 940 ms
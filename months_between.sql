CREATE OR REPLACE FUNCTION months_of(date)
 RETURNS int STRICT IMMUTABLE LANGUAGE sql AS $$
  SELECT extract(years FROM $1)::int * 12 + extract(month FROM $1)::int
$$;

CREATE OR REPLACE FUNCTION months_between(date, date)
 RETURNS int strict immutable language sql as $$
   SELECT months_of(age($1, $2))
$$;

DROP FUNCTION quarters_of(interval);

CREATE OR REPLACE FUNCTION quarters_of(date)
 RETURNS int STRICT IMMUTABLE LANGUAGE sql AS $$
  SELECT extract(years FROM $1)::int * 4 + extract(quarter FROM $1)::int
$$;

CREATE OR REPLACE FUNCTION quarters_between(date, date)
 RETURNS int strict immutable language sql as $$
   SELECT quarters_of($1) - quarters_of($2)
$$;

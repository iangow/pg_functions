-- CREATE LANGUAGE plpythonu;
CREATE OR REPLACE FUNCTION word_count(raw text, min_length int default 1)
  RETURNS integer AS
$BODY$
    """ Function to count the number of words in a passage of text.
        Supplying parameter 'min_length' gives number of words with
        at least min_length letters.
    """
    import nltk
    tokens = nltk.word_tokenize(raw.decode('utf-8'))
    return len([word for word in tokens if len(word) >= min_length])
$BODY$ LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION number_count(raw text)
  RETURNS integer AS
$BODY$
    """ Function to count the number of numbers appearing in a
        passage of text."""
    import re
    results = re.findall(r'\b(?<=-)?[,0-9\.]+(?=\s)', raw)
    results = [result for result in results
                if not re.match(r'(199|20[01])\d', result)
                  and re.search(r'[0-9]', result)]
    return len(results)
$BODY$ LANGUAGE plpythonu;

 CREATE OR REPLACE FUNCTION word_tokenize(raw_text text)
    RETURNS text[] AS
    $BODY$
      import unicodedata
      from nltk.tokenize import wordpunct_tokenize
      words = wordpunct_tokenize(raw_text.decode('utf8'))
      return words
    $BODY$ LANGUAGE plpython2u


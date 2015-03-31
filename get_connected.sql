CREATE OR REPLACE FUNCTION get_connected(
    lhs text[],
    rhs text[])
  RETURNS SETOF text[] AS
$BODY$
    pairs = zip(lhs, rhs)
    from sets import Set

    import networkx as nx
    G=nx.Graph()
    G.add_edges_from(pairs)
    return sorted(nx.connected_components(G), key = len, reverse=True)
    
$BODY$ LANGUAGE plpythonu;

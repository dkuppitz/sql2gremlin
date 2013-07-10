class NorthwindFactory {

  static {
    Gremlin.load()
  }

  public static Graph createGraph() {
    def graph = new TinkerGraph()
    NorthwindFactory.load(graph, 'http://sql2gremlin.com/assets/northwind.xml')
    return graph
  }

  public static void load(final Graph g, final String path) {
    g.createKeyIndex('type', Vertex.class)
    g.createKeyIndex('region', Vertex.class)
    g.createKeyIndex('country', Vertex.class)
    g.createKeyIndex('customerId', Vertex.class)
    g.createKeyIndex('categoryName', Vertex.class)
    g.loadGraphML(path)
  }
}

class NorthwindFactory {

  public static Graph createGraph() {
    def graph = new TinkerGraph()
    NorthwindFactory.load(graph, 'http://sql2gremlin.com/assets/northwind.kryo')
    return graph
  }

  public static void load(final Graph graph, final String path) {
    graph.createKeyIndex('name', Vertex.class)
    graph.createKeyIndex('customerId', Vertex.class)
    graph.io(IoCore.kryo()).loadGraph(path)
  }
}

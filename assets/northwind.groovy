class NorthwindFactory {

  public static Graph createGraph() {
    def graph = TinkerGraph.open()
    NorthwindFactory.load(graph, 'http://sql2gremlin.com/assets/northwind.kryo')
    return graph
  }

  public static void load(final Graph graph, final String path) {
    graph.createIndex('name', Vertex.class)
    graph.createIndex('customerId', Vertex.class)
    graph.io(IoCore.gryo()).readGraph(path)
  }
}

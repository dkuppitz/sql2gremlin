# ![SQL2Gremlin](http://aaronrussell.co.uk/assets/images/labs-illustration.png)

## Introduction

SQL2Gremlin guides you through typical SQL concepts and shows how to do the same in Gremlin. The format of the Gremlin results will not necessarily match the format of the SQL results. Gremlin will often have better ways to structure your results, SQL can only give you tabular data.

The provided Gremlin queries will not necessarily show the optimal way to query the appropriate data. Instead SQL2Gremlin shall show you different Gremlin query concepts. If you have slow queries and need to know a better solution, don't hesitate to ask in the [Gremlin-users group](https://groups.google.com/forum/#!forum/gremlin-users).

The SQL samples will make use of T-SQL syntax. MySQL users might not know some of the concepts (e.g. paging), but should at least be able to understand the queries. The point is, that SQL2Gremlin is not made to teach SQL. You should just focus on each queries short description and the corresponding Gremlin part.

TODO: link http://gremlin.tinkerpop.com
TODO: Northwind blabla. Provide NorthwindFactory.groovy (g = NorthwindFactory.createGraph())

## Select

### Select all

This sample shows how to query all categories.

#### SQL
```sql
SELECT *
  FROM Categories
```

#### Gremlin
```groovy
g.V('type','category')
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)

### Select single column

This sample shows how to query the names of all categories.

**SQL**
```sql
SELECT CategoryName
  FROM Categories
```

**Gremlin**
```groovy
g.V('type','category').categoryName
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)

### Select multiple columns

This sample shows how to query the IDs and names of all categories.

**SQL**
```sql
SELECT CategoryID, CategoryName
  FROM Categories
```

**Gremlin**
```groovy
g.V('type','category').transform({
  [ 'id'   : it.getProperty('categoryId')
  , 'name' : it.getProperty('categoryName') ]
}).categoryName
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin transform step](http://gremlindocs.com/#transform/transform)

### Select calculated column

This sample shows how to query the length of the name of all categories.

**SQL**
```sql
SELECT LENGTH(CategoryName)
  FROM Categories
```

**Gremlin**
```groovy
g.V('type','category').categoryName.transform({it.length()})
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin transform step](http://gremlindocs.com/#transform/transform)
* [Java string length](http://docs.oracle.com/javase/6/docs/api/java/lang/String.html#length%28%29)

### Select distinct values

This sample shows how to query all distinct lengths of category names.

**SQL**
```sql
SELECT DISTINCT LENGTH(CategoryName)
  FROM Categories
```

**Gremlin**
```groovy
g.V('type','category').categoryName.transform({it.length()}).dedup()
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin transform step](http://gremlindocs.com/#transform/transform)
* [Gremlin dedup step](http://gremlindocs.com/#filter/dedup)
* [Java string length](http://docs.oracle.com/javase/6/docs/api/java/lang/String.html#length%28%29)

### Select scalar value

This sample shows how to query the length of the longest category name.

**SQL**
```sql
SELECT MAX(LENGTH(CategoryName))
  FROM Categories
```

**Gremlin**
```groovy
g.V('type','category').categoryName.transform({it.length()}).max()
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin transform step](http://gremlindocs.com/#transform/transform)
* [Java string length](http://docs.oracle.com/javase/6/docs/api/java/lang/String.html#length%28%29)
* [Groovy max method](http://groovy.codehaus.org/groovy-jdk/java/util/Collection.html#max%28%29)

## Filtering

### Filter by equality

This sample shows how to query all products having no unit in stock.

**SQL**
```sql
SELECT *
  FROM Products
 WHERE UnitsInStock = 0
```

**Gremlin**
```groovy
g.V('type','product').has('unitsInStock', 0)
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin has step](http://gremlindocs.com/#filter/has)

### Filter by inequality

This sample shows how to query all products with a unit price not exceeding 10.

**SQL**
```sql
SELECT *
  FROM Products
 WHERE NOT(UnitPrice > 10)
```

**Gremlin**
```groovy
g.V('type','product').hasNot('unitPrice', T.gt, 10f)
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin hasNot step](http://gremlindocs.com/#filter/hasnot)

### Filter by value range

This sample shows how to query all products with a minimum price of 5 and maximum price below 10.

**SQL**
```sql
SELECT *
  FROM Products
 WHERE UnitPrice >= 5 AND UnitPrice < 10
```

**Gremlin**
```groovy
g.V('type','product').interval('unitPrice', 5f, 10f)
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin interval step](http://gremlindocs.com/#filter/interval)

## Ordering

### Order by value ascending

This sample shows how to query all products ordered by unit price.

**SQL**
```sql
  SELECT *
    FROM Products
ORDER BY UnitPrice ASC
```

**Gremlin**
```groovy
g.V('type','product').order({
  it.a.getProperty('unitPrice') <=> it.b.getProperty('unitPrice')
})
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin order step](http://gremlindocs.com/#transform/order)
* [Gremlin property access](http://gremlindocs.com/#transform/key)
* [Groovy spaceship operator](http://groovy.codehaus.org/Operators#Operators-TableofOperators)

### Order by value descending

This sample shows how to query all products ordered by descending unit price.

**SQL**
```sql
  SELECT *
    FROM Products
ORDER BY UnitPrice DESC
```

**Gremlin**
```groovy
g.V('type','product').order({
  it.b.getProperty('unitPrice') <=> it.a.getProperty('unitPrice')
})
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin order step](http://gremlindocs.com/#transform/order)
* [Gremlin property access](http://gremlindocs.com/#transform/key)
* [Groovy spaceship operator](http://groovy.codehaus.org/Operators#Operators-TableofOperators)

## Paging

### Limit number of results

This sample shows how to query the first 5 products ordered by unit price.

**SQL**
```sql
  SELECT TOP (5) *
    FROM Products
ORDER BY UnitPrice
```

**Gremlin**
```groovy
g.V('type','product').order({
  it.b.getProperty('unitPrice') <=> it.a.getProperty('unitPrice')
})[0..<5]
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin order step](http://gremlindocs.com/#transform/order)
* [Gremlin property access](http://gremlindocs.com/#transform/key)
* [Gremlin range filter](http://gremlindocs.com/#filter/i-j)
* [Groovy spaceship operator](http://groovy.codehaus.org/Operators#Operators-TableofOperators)

### Paged result set

This sample shows how to query the next 5 products (page 2) ordered by unit price.

**SQL**
```sql
   SELECT Products.*
     FROM (SELECT ROW_NUMBER()
                    OVER (
                      ORDER BY UnitPrice) AS [ROW_NUMBER],
                  ProductID
             FROM Products) AS SortedProducts
       INNER JOIN Products
               ON Products.ProductID = SortedProducts.ProductID
    WHERE [ROW_NUMBER] BETWEEN 6 AND 10
 ORDER BY [ROW_NUMBER]
```

**Gremlin**
```groovy
g.V('type','product').order({
  it.b.getProperty('unitPrice') <=> it.a.getProperty('unitPrice')
})[5..<10]
```

**References:**

* [Gremlin vertex iterator](http://gremlindocs.com/#transform/v)
* [Gremlin order step](http://gremlindocs.com/#transform/order)
* [Gremlin property access](http://gremlindocs.com/#transform/key)
* [Gremlin range filter](http://gremlindocs.com/#filter/i-j)
* [Groovy spaceship operator](http://groovy.codehaus.org/Operators#Operators-TableofOperators)

## Joining

TODO

## Grouping

TODO

## CTE

Maybe

## Pivots

Maybe
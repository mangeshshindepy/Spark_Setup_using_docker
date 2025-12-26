# Apache Spark Docker Exam Cheat Sheet (Windows)

Run Spark using Docker Compose on Windows and practice RDD, DataFrame, and SQL concepts commonly tested in exams.

Prerequisites
Windows 10/11
Docker Desktop (WSL2 enabled)
Docker Compose

Docker commands
docker-compose down
docker system prune -f
docker compose up --build
docker-compose up --build

Spark shell
docker exec -it spark-master pyspark --master spark://spark-master:7077
docker exec -it spark-master bash

Spark UIs
Master UI  http://localhost:8080
Worker UI  http://localhost:8081
Spark UI   http://localhost:4040

Spark config (disable AQE for learning stages)
spark.conf.set("spark.sql.adaptive.enabled", "false")

RDD BASICS

Create RDD (lazy)
rdd = sc.parallelize(range(1, 1000001), 4)

Narrow transformations (no shuffle)
rdd.map(lambda x: x * 2)
rdd.filter(lambda x: x % 2 == 0)

Action (triggers job)
rdd.count()
rdd.collect()
rdd.take(10)

Wide transformations (shuffle)
rdd.map(lambda x: (x % 10, 1)).groupByKey()
rdd.map(lambda x: (x % 10, 1)).reduceByKey(lambda a, b: a + b)

Prefer reduceByKey over groupByKey (exam rule)

Cache and persist
rdd.cache()
rdd.persist()
rdd.persist(StorageLevel.MEMORY_AND_DISK)
rdd.unpersist()

RDD Exam Notes
Transformations are lazy
Actions trigger jobs
Narrow = single stage
Wide = shuffle + multiple stages
Cache only if reused
Shuffles are expensive

DATAFRAME BASICS

Create DataFrame
df = spark.range(1, 1000001)

Schema
df.printSchema()

Select
df.select("id")
df.selectExpr("id", "id * 2 as double_id")

Filter
df.filter(df.id > 100)
df.where("id > 100")

Aggregation
df.groupBy(df.id % 10).count()

Actions
df.show()
df.count()
df.collect()

DataFrame Exam Notes
DataFrames are optimized (Catalyst + Tungsten)
Prefer DataFrame over RDD when possible
Operations are lazy
Actions trigger execution

SPARK SQL

Create temp view
df.createOrReplaceTempView("numbers")

Run SQL
spark.sql("SELECT * FROM numbers WHERE id > 100").show()
spark.sql("SELECT id % 10 AS key, COUNT(*) FROM numbers GROUP BY key").show()

SQL Exam Notes
Spark SQL uses Catalyst optimizer
SQL, DataFrame, and Dataset share same execution engine
Temp views are session-scoped

RDD vs DataFrame (Exam Favorite)
RDD = low-level, no optimization
DataFrame = optimized, easier, faster
Use RDD only when low-level control is needed

Stop cluster
docker-compose down

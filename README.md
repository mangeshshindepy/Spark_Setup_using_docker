# Apache Spark with Docker on Windows

This README explains how to run Apache Spark using Docker Compose on Windows,
access Spark UIs, and practice core Spark concepts such as RDD transformations,
actions, shuffle, caching, and persistence.

===============================================================================

PREREQUISITES

- Windows 10 / 11
- Docker Desktop (WSL2 enabled)
- Docker Compose

===============================================================================

DOCKER CLEANUP (OPTIONAL)

docker-compose down
docker system prune -f

===============================================================================

BUILD AND START SPARK CLUSTER

docker compose up --build
OR
docker-compose up --build

===============================================================================

ACCESS SPARK CONTAINERS

START PYSPARK SHELL

docker exec -it spark-master pyspark --master spark://spark-master:7077

ACCESS SPARK MASTER CONTAINER (NO REBUILD)

docker exec -it spark-master bash

===============================================================================

SPARK WEB UIs

MASTER UI  : http://localhost:8080
WORKER UI  : http://localhost:8081
SPARK UI   : http://localhost:4040

===============================================================================

SPARK CONFIGURATION (LEARNING MODE)

Disable Adaptive Query Execution (AQE) to clearly observe shuffles and stages

spark.conf.set("spark.sql.adaptive.enabled", "false")

===============================================================================

SPARK RDD EXAMPLES

BASE RDD – LAZY EVALUATION

rdd = sc.parallelize(range(1, 1000001), 4)

-------------------------------------------------------------------------------

NARROW TRANSFORMATIONS (NO SHUFFLE)

mapped = rdd.map(lambda x: x * 2)
filtered = mapped.filter(lambda x: x % 3 == 0)

-------------------------------------------------------------------------------

ACTION – TRIGGERS JOB + STAGE + TASKS

count = filtered.count()
print(count)

-------------------------------------------------------------------------------

WIDE TRANSFORMATION (SHUFFLE HAPPENS)

pairs = rdd.map(lambda x: (x % 10, 1))
grouped = pairs.reduceByKey(lambda a, b: a + b)

-------------------------------------------------------------------------------

ACTION – OBSERVE SHUFFLE IN SPARK UI

result = grouped.collect()
print(result)

===============================================================================

CACHING AND PERSISTENCE

CACHE() – MEMORY ONLY (LAZY)

cached_rdd = grouped.cache()
cached_rdd.count()

REUSE CACHED RDD (NO RECOMPUTATION)

cached_rdd.collect()

-------------------------------------------------------------------------------

PERSIST() – MEMORY AND DISK

from pyspark import StorageLevel

persisted = grouped.persist(StorageLevel.MEMORY_AND_DISK)
persisted.count()

-------------------------------------------------------------------------------

FORCING RECOMPUTATION

persisted.unpersist()
persisted.collect()

===============================================================================

NARROW VS WIDE TRANSFORMATIONS (IMPORTANT CONCEPT)

NARROW TRANSFORMATION

rdd.map(lambda x: x + 1).filter(lambda x: x > 10).count()

- No shuffle
- Single stage
- Faster execution

-------------------------------------------------------------------------------

WIDE TRANSFORMATION

rdd.map(lambda x: (x % 5, x)).groupByKey().count()

- Shuffle occurs
- Multiple stages
- Expensive operation

===============================================================================

STOP THE SPARK CLUSTER

docker-compose down

===============================================================================

NOTES

- Always monitor the Spark UI when learning shuffles and stages
- Prefer reduceByKey over groupByKey
- Cache only when RDDs are reused

===============================================================================

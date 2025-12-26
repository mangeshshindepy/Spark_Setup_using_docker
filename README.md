# Apache Spark with Docker on Windows

This README explains how to run **Apache Spark** using **Docker Compose** on **Windows**, access Spark UIs, and practice core Spark concepts such as **RDD transformations, actions, shuffle, caching, and persistence**.

---

## Prerequisites

- Windows 10 / 11
- Docker Desktop (WSL2 enabled)
- Docker Compose

---

## Docker Cleanup (Optional)

```bash
docker-compose down
docker system prune -f




docker-compose down
docker system prune -f

docker compose up --build 
OR
docker-compose up --build

#START SPARK SHELL
docker exec -it spark-master pyspark --master spark://spark-master:7077

#OR WITHOUT REBUILD
docker exec -it spark-master bash

#MASTER_UI
http://localhost:8080

#WORKER_UI
http://localhost:8081

#SPARK_UI
http://localhost:4040

#When learning shuffle/stages, disable AQE:
spark.conf.set("spark.sql.adaptive.enabled", "false")


#Base RDD – observe lazy evaluation
rdd = sc.parallelize(range(1, 1000001), 4)

#Narrow Transformations (NO shuffle)
mapped = rdd.map(lambda x: x * 2)
filtered = mapped.filter(lambda x: x % 3 == 0)

#First Action → Job + Stage + Tasks
count = filtered.count()
print(count)

#Wide Transformation (SHUFFLE happens)
pairs = rdd.map(lambda x: (x % 10, 1))
grouped = pairs.reduceByKey(lambda a, b: a + b)


#Action → Observe shuffle in Spark UI
result = grouped.collect()
print(result)


#cache() – MEMORY ONLY (lazy)
cached_rdd = grouped.cache()


cached_rdd.count()

#Use cached RDD again (NO recomputation)
cached_rdd.collect()


#persist() – control memory & disk
from pyspark import StorageLevel

persisted = grouped.persist(StorageLevel.MEMORY_AND_DISK)
persisted.count()

#Forcing recomputation (unpersist)
persisted.unpersist()
persisted.collect()

#Compare narrow vs wide (important exam question)
# Narrow
rdd.map(lambda x: x + 1).filter(lambda x: x > 10).count()

# Wide
rdd.map(lambda x: (x % 5, x)).groupByKey().count()




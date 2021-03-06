-- 输入数据不按字段分割，当前一个String 类型的字段，交由后续的sql 处理
-- kafka source
drop table if exists user_log ;
CREATE TABLE user_log (
    str varchar
) WITH (
  'connector.type' = 'kafka'
  ,'connector.version' = 'universal'
  ,'connector.topic' = 'user_behavior'                            -- required: topic name from which the table is read
  ,'connector.properties.zookeeper.connect' = 'venn:2181'    -- required: specify the ZooKeeper connection string
  ,'connector.properties.bootstrap.servers' = 'venn:9092'    -- required: specify the Kafka server connection string
  ,'connector.properties.group.id' = 'user_log'                   -- optional: required in Kafka consumer, specify consumer group
  ,'connector.startup-mode' = 'group-offsets'                     -- optional: valid modes are "earliest-offset", "latest-offset", "group-offsets",  "specific-offsets"
  ,'connector.sink-partitioner' = 'fixed'                         --optional fixed 每个 flink 分区数据只发到 一个 kafka 分区
                                                                          -- round-robin flink 分区轮询分配到 kafka 分区
                                                                          -- custom 自定义分区策略
  --,'connector.sink-partitioner-class' = 'org.mycompany.MyPartitioner'   -- 自定义分区类
  ,'format.type' = 'csv'                 -- required:  'csv', 'json' and 'avro'.
  ,'format.field-delimiter' = '|'
);

-- kafka sink
drop table if exists user_log_sink ;
CREATE TABLE user_log_sink (
  str varchar
) WITH (
    'connector' = 'print'
);

-- insert
insert into user_log_sink
select str
from user_log;


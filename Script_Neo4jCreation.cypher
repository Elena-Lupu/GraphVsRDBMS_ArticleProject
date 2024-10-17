:begin
CREATE CONSTRAINT UNIQUE_IMPORT_NAME FOR (node:`UNIQUE IMPORT LABEL`) REQUIRE (node.`UNIQUE IMPORT ID`) IS UNIQUE;
:commit
CALL db.awaitIndexes(300);
:begin
UNWIND [{_id:8, properties:{name:"Scari_1", type:"scari"}}, {_id:9, properties:{name:"Scari_Mici", type:"scari"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:sala:scari;
UNWIND [{_id:11, properties:{name:"Iesire_1", type:"exterior"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:exteriorr:sala;
UNWIND [{_id:1, properties:{name:"PR106a", type:"sala"}}, {_id:2, properties:{name:"PR206b", type:"sala"}}, {_id:3, properties:{name:"PR203b", type:"sala"}}, {_id:4, properties:{name:"PR208b", type:"sala"}}, {_id:5, properties:{name:"PR306b", type:"sala"}}, {_id:6, properties:{name:"PR303b", type:"sala"}}, {_id:7, properties:{name:"PR308b", type:"sala"}}, {_id:12, properties:{name:"PR001", type:"sala"}}, {_id:13, properties:{name:"PR002", type:"sala"}}, {_id:14, properties:{name:"PR003a", type:"sala"}}, {_id:15, properties:{name:"PR101", type:"sala"}}, {_id:16, properties:{name:"PR201", type:"sala"}}, {_id:17, properties:{name:"PR202", type:"sala"}}, {_id:18, properties:{name:"PR203a", type:"sala"}}, {_id:19, properties:{name:"PR204", type:"sala"}}, {_id:20, properties:{name:"PR205", type:"sala"}}, {_id:21, properties:{name:"PR206a", type:"sala"}}, {_id:22, properties:{name:"PR207", type:"sala"}}, {_id:23, properties:{name:"PR208a", type:"sala"}}, {_id:24, properties:{name:"PR301", type:"sala"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:sala;
UNWIND [{_id:25, properties:{name:"PR302", type:"sala"}}, {_id:26, properties:{name:"PR303a", type:"sala"}}, {_id:27, properties:{name:"PR304", type:"sala"}}, {_id:28, properties:{name:"PR305", type:"sala"}}, {_id:29, properties:{name:"PR306a", type:"sala"}}, {_id:30, properties:{name:"PR307", type:"sala"}}, {_id:31, properties:{name:"PR308a", type:"sala"}}, {_id:32, properties:{name:"PR401", type:"sala"}}, {_id:33, properties:{name:"PR402", type:"sala"}}, {_id:34, properties:{name:"PR403a", type:"sala"}}, {_id:35, properties:{name:"PR404", type:"sala"}}, {_id:36, properties:{name:"PR405", type:"sala"}}, {_id:37, properties:{name:"PR406a", type:"sala"}}, {_id:38, properties:{name:"PR407", type:"sala"}}, {_id:39, properties:{name:"PR408a", type:"sala"}}, {_id:40, properties:{name:"PR501", type:"sala"}}, {_id:41, properties:{name:"PR502", type:"sala"}}, {_id:42, properties:{name:"PR503a", type:"sala"}}, {_id:43, properties:{name:"PR504", type:"sala"}}, {_id:44, properties:{name:"PR505", type:"sala"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:sala;
UNWIND [{_id:45, properties:{name:"PR506a", type:"sala"}}, {_id:46, properties:{name:"PR507", type:"sala"}}, {_id:47, properties:{name:"PR508a", type:"sala"}}, {_id:48, properties:{name:"PR601", type:"sala"}}, {_id:49, properties:{name:"PR602", type:"sala"}}, {_id:50, properties:{name:"PR603a", type:"sala"}}, {_id:51, properties:{name:"PR604", type:"sala"}}, {_id:52, properties:{name:"PR605", type:"sala"}}, {_id:53, properties:{name:"PR606a", type:"sala"}}, {_id:54, properties:{name:"PR607", type:"sala"}}, {_id:55, properties:{name:"PR608a", type:"sala"}}, {_id:56, properties:{name:"PR701", type:"sala"}}, {_id:57, properties:{name:"PR702", type:"sala"}}, {_id:58, properties:{name:"PR703a", type:"sala"}}, {_id:59, properties:{name:"PR704", type:"sala"}}, {_id:60, properties:{name:"PR705", type:"sala"}}, {_id:61, properties:{name:"PR706a", type:"sala"}}, {_id:62, properties:{name:"PR707", type:"sala"}}, {_id:63, properties:{name:"PR708a", type:"sala"}}, {_id:64, properties:{name:"PR004", type:"sala"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:sala;
UNWIND [{_id:65, properties:{name:"PR005", type:"sala"}}, {_id:66, properties:{name:"PR102", type:"sala"}}, {_id:67, properties:{name:"PR103a", type:"sala"}}, {_id:68, properties:{name:"PR103b", type:"sala"}}, {_id:69, properties:{name:"PR104", type:"sala"}}, {_id:70, properties:{name:"PR105", type:"sala"}}, {_id:71, properties:{name:"PR106b", type:"sala"}}, {_id:72, properties:{name:"PR107", type:"sala"}}, {_id:73, properties:{name:"PR406b", type:"sala"}}, {_id:75, properties:{name:"PR408b", type:"sala"}}, {_id:76, properties:{name:"PR403b", type:"sala"}}, {_id:77, properties:{name:"PR508b", type:"sala"}}, {_id:78, properties:{name:"PR506b", type:"sala"}}, {_id:79, properties:{name:"PR503b", type:"sala"}}, {_id:80, properties:{name:"PR608b", type:"sala"}}, {_id:81, properties:{name:"PR603b", type:"sala"}}, {_id:82, properties:{name:"PR606b", type:"sala"}}, {_id:83, properties:{name:"PR708b", type:"sala"}}, {_id:84, properties:{name:"PR706b", type:"sala"}}, {_id:85, properties:{name:"PR703b", type:"sala"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:sala;
UNWIND [{_id:86, properties:{name:"PR003b", type:"sala"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:sala;
UNWIND [{_id:10, properties:{name:"Lift", type:"lift"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:sala:lift;
UNWIND [{_id:74, properties:{name:"Iesire_2", type:"exterior"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:exteriorr;
UNWIND [{_id:0, properties:{name:"Scari_2", type:"scari"}}] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:scari;
:commit
:begin
UNWIND [{start: {_id:11}, end: {_id:10}, properties:{pondere:4}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:0}, end: {_id:13}, properties:{pondere:1}}, {start: {_id:0}, end: {_id:70}, properties:{pondere:1}}, {start: {_id:0}, end: {_id:44}, properties:{pondere:1}}, {start: {_id:0}, end: {_id:20}, properties:{pondere:1}}, {start: {_id:0}, end: {_id:28}, properties:{pondere:1}}, {start: {_id:0}, end: {_id:36}, properties:{pondere:1}}, {start: {_id:0}, end: {_id:60}, properties:{pondere:1}}, {start: {_id:0}, end: {_id:52}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:74}, end: {_id:9}, properties:{pondere:1}}, {start: {_id:74}, end: {_id:8}, properties:{pondere:2}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:9}, end: {_id:8}, properties:{pondere:1}}, {start: {_id:8}, end: {_id:9}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:9}, end: {_id:72}, properties:{pondere:1}}, {start: {_id:9}, end: {_id:15}, properties:{pondere:2}}, {start: {_id:8}, end: {_id:72}, properties:{pondere:2}}, {start: {_id:8}, end: {_id:23}, properties:{pondere:1}}, {start: {_id:8}, end: {_id:31}, properties:{pondere:1}}, {start: {_id:8}, end: {_id:39}, properties:{pondere:1}}, {start: {_id:8}, end: {_id:47}, properties:{pondere:1}}, {start: {_id:8}, end: {_id:55}, properties:{pondere:1}}, {start: {_id:8}, end: {_id:63}, properties:{pondere:1}}, {start: {_id:8}, end: {_id:15}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:72}, end: {_id:9}, properties:{pondere:1}}, {start: {_id:15}, end: {_id:9}, properties:{pondere:2}}, {start: {_id:72}, end: {_id:8}, properties:{pondere:2}}, {start: {_id:23}, end: {_id:8}, properties:{pondere:1}}, {start: {_id:31}, end: {_id:8}, properties:{pondere:1}}, {start: {_id:39}, end: {_id:8}, properties:{pondere:1}}, {start: {_id:47}, end: {_id:8}, properties:{pondere:1}}, {start: {_id:55}, end: {_id:8}, properties:{pondere:1}}, {start: {_id:63}, end: {_id:8}, properties:{pondere:1}}, {start: {_id:15}, end: {_id:8}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:12}, end: {_id:11}, properties:{pondere:1}}, {start: {_id:13}, end: {_id:11}, properties:{pondere:1}}, {start: {_id:65}, end: {_id:11}, properties:{pondere:5}}, {start: {_id:64}, end: {_id:11}, properties:{pondere:4}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:11}, end: {_id:8}, properties:{pondere:4}}, {start: {_id:11}, end: {_id:9}, properties:{pondere:5}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:65}, end: {_id:64}, properties:{pondere:1}}, {start: {_id:64}, end: {_id:65}, properties:{pondere:1}}, {start: {_id:14}, end: {_id:86}, properties:{pondere:1}}, {start: {_id:86}, end: {_id:14}, properties:{pondere:1}}, {start: {_id:15}, end: {_id:66}, properties:{pondere:1}}, {start: {_id:66}, end: {_id:15}, properties:{pondere:1}}, {start: {_id:15}, end: {_id:68}, properties:{pondere:1}}, {start: {_id:68}, end: {_id:15}, properties:{pondere:1}}, {start: {_id:67}, end: {_id:68}, properties:{pondere:1}}, {start: {_id:68}, end: {_id:67}, properties:{pondere:1}}, {start: {_id:67}, end: {_id:69}, properties:{pondere:1}}, {start: {_id:69}, end: {_id:67}, properties:{pondere:1}}, {start: {_id:70}, end: {_id:69}, properties:{pondere:1}}, {start: {_id:69}, end: {_id:70}, properties:{pondere:1}}, {start: {_id:70}, end: {_id:71}, properties:{pondere:1}}, {start: {_id:71}, end: {_id:70}, properties:{pondere:1}}, {start: {_id:1}, end: {_id:71}, properties:{pondere:1}}, {start: {_id:71}, end: {_id:1}, properties:{pondere:1}}, {start: {_id:1}, end: {_id:72}, properties:{pondere:1}}, {start: {_id:72}, end: {_id:1}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:20}, end: {_id:2}, properties:{pondere:1}}, {start: {_id:2}, end: {_id:20}, properties:{pondere:1}}, {start: {_id:21}, end: {_id:2}, properties:{pondere:1}}, {start: {_id:2}, end: {_id:21}, properties:{pondere:1}}, {start: {_id:20}, end: {_id:19}, properties:{pondere:1}}, {start: {_id:19}, end: {_id:20}, properties:{pondere:1}}, {start: {_id:19}, end: {_id:3}, properties:{pondere:1}}, {start: {_id:3}, end: {_id:19}, properties:{pondere:1}}, {start: {_id:18}, end: {_id:3}, properties:{pondere:1}}, {start: {_id:3}, end: {_id:18}, properties:{pondere:1}}, {start: {_id:18}, end: {_id:17}, properties:{pondere:1}}, {start: {_id:17}, end: {_id:18}, properties:{pondere:1}}, {start: {_id:23}, end: {_id:17}, properties:{pondere:1}}, {start: {_id:17}, end: {_id:23}, properties:{pondere:1}}, {start: {_id:85}, end: {_id:58}, properties:{pondere:1}}, {start: {_id:58}, end: {_id:85}, properties:{pondere:1}}, {start: {_id:23}, end: {_id:4}, properties:{pondere:1}}, {start: {_id:4}, end: {_id:23}, properties:{pondere:1}}, {start: {_id:22}, end: {_id:4}, properties:{pondere:1}}, {start: {_id:4}, end: {_id:22}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:22}, end: {_id:21}, properties:{pondere:1}}, {start: {_id:21}, end: {_id:22}, properties:{pondere:1}}, {start: {_id:16}, end: {_id:17}, properties:{pondere:1}}, {start: {_id:17}, end: {_id:16}, properties:{pondere:1}}, {start: {_id:28}, end: {_id:27}, properties:{pondere:1}}, {start: {_id:27}, end: {_id:28}, properties:{pondere:1}}, {start: {_id:6}, end: {_id:27}, properties:{pondere:1}}, {start: {_id:27}, end: {_id:6}, properties:{pondere:1}}, {start: {_id:25}, end: {_id:24}, properties:{pondere:1}}, {start: {_id:24}, end: {_id:25}, properties:{pondere:1}}, {start: {_id:6}, end: {_id:26}, properties:{pondere:1}}, {start: {_id:26}, end: {_id:6}, properties:{pondere:1}}, {start: {_id:25}, end: {_id:26}, properties:{pondere:1}}, {start: {_id:26}, end: {_id:25}, properties:{pondere:1}}, {start: {_id:5}, end: {_id:29}, properties:{pondere:1}}, {start: {_id:29}, end: {_id:5}, properties:{pondere:1}}, {start: {_id:5}, end: {_id:28}, properties:{pondere:1}}, {start: {_id:28}, end: {_id:5}, properties:{pondere:1}}, {start: {_id:29}, end: {_id:30}, properties:{pondere:1}}, {start: {_id:30}, end: {_id:29}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:30}, end: {_id:7}, properties:{pondere:1}}, {start: {_id:7}, end: {_id:30}, properties:{pondere:1}}, {start: {_id:85}, end: {_id:59}, properties:{pondere:1}}, {start: {_id:59}, end: {_id:85}, properties:{pondere:1}}, {start: {_id:25}, end: {_id:31}, properties:{pondere:1}}, {start: {_id:31}, end: {_id:25}, properties:{pondere:1}}, {start: {_id:7}, end: {_id:31}, properties:{pondere:1}}, {start: {_id:31}, end: {_id:7}, properties:{pondere:1}}, {start: {_id:36}, end: {_id:35}, properties:{pondere:1}}, {start: {_id:35}, end: {_id:36}, properties:{pondere:1}}, {start: {_id:33}, end: {_id:34}, properties:{pondere:1}}, {start: {_id:34}, end: {_id:33}, properties:{pondere:1}}, {start: {_id:33}, end: {_id:32}, properties:{pondere:1}}, {start: {_id:32}, end: {_id:33}, properties:{pondere:1}}, {start: {_id:33}, end: {_id:39}, properties:{pondere:1}}, {start: {_id:39}, end: {_id:33}, properties:{pondere:1}}, {start: {_id:59}, end: {_id:60}, properties:{pondere:1}}, {start: {_id:60}, end: {_id:59}, properties:{pondere:1}}, {start: {_id:37}, end: {_id:38}, properties:{pondere:1}}, {start: {_id:38}, end: {_id:37}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:37}, end: {_id:73}, properties:{pondere:1}}, {start: {_id:73}, end: {_id:37}, properties:{pondere:1}}, {start: {_id:75}, end: {_id:38}, properties:{pondere:1}}, {start: {_id:38}, end: {_id:75}, properties:{pondere:1}}, {start: {_id:75}, end: {_id:39}, properties:{pondere:1}}, {start: {_id:39}, end: {_id:75}, properties:{pondere:1}}, {start: {_id:73}, end: {_id:36}, properties:{pondere:1}}, {start: {_id:36}, end: {_id:73}, properties:{pondere:1}}, {start: {_id:76}, end: {_id:34}, properties:{pondere:1}}, {start: {_id:34}, end: {_id:76}, properties:{pondere:1}}, {start: {_id:76}, end: {_id:35}, properties:{pondere:1}}, {start: {_id:35}, end: {_id:76}, properties:{pondere:1}}, {start: {_id:44}, end: {_id:43}, properties:{pondere:1}}, {start: {_id:43}, end: {_id:44}, properties:{pondere:1}}, {start: {_id:79}, end: {_id:43}, properties:{pondere:1}}, {start: {_id:43}, end: {_id:79}, properties:{pondere:1}}, {start: {_id:79}, end: {_id:42}, properties:{pondere:1}}, {start: {_id:42}, end: {_id:79}, properties:{pondere:1}}, {start: {_id:41}, end: {_id:42}, properties:{pondere:1}}, {start: {_id:42}, end: {_id:41}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:41}, end: {_id:40}, properties:{pondere:1}}, {start: {_id:40}, end: {_id:41}, properties:{pondere:1}}, {start: {_id:41}, end: {_id:47}, properties:{pondere:1}}, {start: {_id:47}, end: {_id:41}, properties:{pondere:1}}, {start: {_id:77}, end: {_id:47}, properties:{pondere:1}}, {start: {_id:47}, end: {_id:77}, properties:{pondere:1}}, {start: {_id:77}, end: {_id:46}, properties:{pondere:1}}, {start: {_id:46}, end: {_id:77}, properties:{pondere:1}}, {start: {_id:45}, end: {_id:46}, properties:{pondere:1}}, {start: {_id:46}, end: {_id:45}, properties:{pondere:1}}, {start: {_id:45}, end: {_id:78}, properties:{pondere:1}}, {start: {_id:78}, end: {_id:45}, properties:{pondere:1}}, {start: {_id:44}, end: {_id:78}, properties:{pondere:1}}, {start: {_id:78}, end: {_id:44}, properties:{pondere:1}}, {start: {_id:52}, end: {_id:51}, properties:{pondere:1}}, {start: {_id:51}, end: {_id:52}, properties:{pondere:1}}, {start: {_id:81}, end: {_id:51}, properties:{pondere:1}}, {start: {_id:51}, end: {_id:81}, properties:{pondere:1}}, {start: {_id:81}, end: {_id:50}, properties:{pondere:1}}, {start: {_id:50}, end: {_id:81}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:49}, end: {_id:50}, properties:{pondere:1}}, {start: {_id:50}, end: {_id:49}, properties:{pondere:1}}, {start: {_id:49}, end: {_id:48}, properties:{pondere:1}}, {start: {_id:48}, end: {_id:49}, properties:{pondere:1}}, {start: {_id:49}, end: {_id:55}, properties:{pondere:1}}, {start: {_id:55}, end: {_id:49}, properties:{pondere:1}}, {start: {_id:80}, end: {_id:55}, properties:{pondere:1}}, {start: {_id:55}, end: {_id:80}, properties:{pondere:1}}, {start: {_id:54}, end: {_id:80}, properties:{pondere:1}}, {start: {_id:80}, end: {_id:54}, properties:{pondere:1}}, {start: {_id:54}, end: {_id:53}, properties:{pondere:1}}, {start: {_id:53}, end: {_id:54}, properties:{pondere:1}}, {start: {_id:82}, end: {_id:53}, properties:{pondere:1}}, {start: {_id:53}, end: {_id:82}, properties:{pondere:1}}, {start: {_id:82}, end: {_id:52}, properties:{pondere:1}}, {start: {_id:52}, end: {_id:82}, properties:{pondere:1}}, {start: {_id:58}, end: {_id:57}, properties:{pondere:1}}, {start: {_id:57}, end: {_id:58}, properties:{pondere:1}}, {start: {_id:63}, end: {_id:57}, properties:{pondere:1}}, {start: {_id:57}, end: {_id:63}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:56}, end: {_id:57}, properties:{pondere:1}}, {start: {_id:57}, end: {_id:56}, properties:{pondere:1}}, {start: {_id:63}, end: {_id:83}, properties:{pondere:1}}, {start: {_id:83}, end: {_id:63}, properties:{pondere:1}}, {start: {_id:62}, end: {_id:83}, properties:{pondere:1}}, {start: {_id:83}, end: {_id:62}, properties:{pondere:1}}, {start: {_id:62}, end: {_id:61}, properties:{pondere:1}}, {start: {_id:61}, end: {_id:62}, properties:{pondere:1}}, {start: {_id:84}, end: {_id:61}, properties:{pondere:1}}, {start: {_id:61}, end: {_id:84}, properties:{pondere:1}}, {start: {_id:84}, end: {_id:60}, properties:{pondere:1}}, {start: {_id:60}, end: {_id:84}, properties:{pondere:1}}, {start: {_id:86}, end: {_id:13}, properties:{pondere:1}}, {start: {_id:13}, end: {_id:86}, properties:{pondere:1}}, {start: {_id:14}, end: {_id:64}, properties:{pondere:1}}, {start: {_id:64}, end: {_id:14}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:65}, end: {_id:74}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:10}, end: {_id:8}, properties:{pondere:1}}, {start: {_id:10}, end: {_id:9}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:8}, end: {_id:11}, properties:{pondere:4}}, {start: {_id:9}, end: {_id:11}, properties:{pondere:5}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:11}, end: {_id:74}, properties:{pondere:5}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:8}, end: {_id:10}, properties:{pondere:1}}, {start: {_id:9}, end: {_id:10}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:11}, end: {_id:12}, properties:{pondere:1}}, {start: {_id:11}, end: {_id:13}, properties:{pondere:1}}, {start: {_id:11}, end: {_id:65}, properties:{pondere:5}}, {start: {_id:11}, end: {_id:64}, properties:{pondere:4}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:13}, end: {_id:0}, properties:{pondere:1}}, {start: {_id:70}, end: {_id:0}, properties:{pondere:1}}, {start: {_id:44}, end: {_id:0}, properties:{pondere:1}}, {start: {_id:20}, end: {_id:0}, properties:{pondere:1}}, {start: {_id:28}, end: {_id:0}, properties:{pondere:1}}, {start: {_id:36}, end: {_id:0}, properties:{pondere:1}}, {start: {_id:60}, end: {_id:0}, properties:{pondere:1}}, {start: {_id:52}, end: {_id:0}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:74}, end: {_id:11}, properties:{pondere:5}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:10}, end: {_id:11}, properties:{pondere:4}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:74}, end: {_id:65}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:10}, end: {_id:15}, properties:{pondere:1}}, {start: {_id:10}, end: {_id:72}, properties:{pondere:2}}, {start: {_id:10}, end: {_id:23}, properties:{pondere:1}}, {start: {_id:10}, end: {_id:31}, properties:{pondere:1}}, {start: {_id:10}, end: {_id:39}, properties:{pondere:1}}, {start: {_id:10}, end: {_id:47}, properties:{pondere:1}}, {start: {_id:10}, end: {_id:55}, properties:{pondere:1}}, {start: {_id:10}, end: {_id:63}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:15}, end: {_id:10}, properties:{pondere:1}}, {start: {_id:72}, end: {_id:10}, properties:{pondere:2}}, {start: {_id:23}, end: {_id:10}, properties:{pondere:1}}, {start: {_id:31}, end: {_id:10}, properties:{pondere:1}}, {start: {_id:39}, end: {_id:10}, properties:{pondere:1}}, {start: {_id:47}, end: {_id:10}, properties:{pondere:1}}, {start: {_id:55}, end: {_id:10}, properties:{pondere:1}}, {start: {_id:63}, end: {_id:10}, properties:{pondere:1}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
UNWIND [{start: {_id:9}, end: {_id:74}, properties:{pondere:1}}, {start: {_id:8}, end: {_id:74}, properties:{pondere:2}}] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:r]->(end) SET r += row.properties;
:commit
:begin
MATCH (n:`UNIQUE IMPORT LABEL`)  WITH n LIMIT 20000 REMOVE n:`UNIQUE IMPORT LABEL` REMOVE n.`UNIQUE IMPORT ID`;
:commit
:begin
DROP CONSTRAINT UNIQUE_IMPORT_NAME;
:commit

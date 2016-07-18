@rem set SPARK_HOME=E:\Temp\Livy\spark-1.5.1-nao-0.1-sparkvso-h2.6.1-nao-0.1-s2.10
@rem set SPARKCLR_HOME=E:\BigData\Hadoop\etc\hadoop
@rem set HADOOP_CONF_DIR=E:\Projects\DevBox\Mobusis\SparkClient\Mobius


set LIVY_HADOOP_CLASSPATH="%SPARK_HOME%\Hadoop\etc\hadoop;%SPARK_HOME%\Hadoop\share\hadoop\common\lib\*;%SPARK_HOME%\Hadoop\share\hadoop\common\*;%SPARK_HOME%\Hadoop\share\hadoop\hdfs;%SPARK_HOME%\Hadoop\share\hadoop\hdfs\lib\*;%SPARK_HOME%\Hadoop\share\hadoop\hdfs\*;%SPARK_HOME%\Hadoop\share\hadoop\yarn\lib\*;%SPARK_HOME%\Hadoop\share\hadoop\yarn\*;%SPARK_HOME%\Hadoop\share\hadoop\mapreduce\lib\*;%SPARK_HOME%\Hadoop\share\hadoop\mapreduce\*"

set LIVY_HOME=%cd%
set ASSEMBLY_DIR=%LIVY_HOME%\livy-assembly\target\scala-2.10
set ASSEMBLY_JAR=%ASSEMBLY_DIR%\livy-assembly-0.2.0-SNAPSHOT.jar
set CLASSPATH=%ASSEMBLY_DIR%\*;%LIVY_HOME%;%ASSEMBLY_JAR%;%LIVY_HADOOP_CLASSPATH%;%CLASSPATH%
set LIVY_SERVER_JAVA_OPTS=-Dlivy.server.session.factory=yarn
call java %LIVY_SERVER_JAVA_OPTS% -cp %CLASSPATH% com.cloudera.hue.livy.server.Main

/*
 * Licensed to Cloudera, Inc. under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  Cloudera, Inc. licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.cloudera.hue.livy.spark

import com.cloudera.hue.livy.{NaoLivyConf, LivyConf, Logging}

import scala.collection.JavaConversions._
import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer

class NaoSparkProcessBuilder(livyConf: LivyConf, userConfigurableOptions: Set[String]) extends SparkProcessBuilder(livyConf, userConfigurableOptions) {
    import SparkProcessBuilder._

    override def start(file: Path, args: Traversable[String]): SparkProcess = {
        def startProcessBaseOnClassName(className: String, file: Path, args: Traversable[String]): SparkProcess = {
            if(className.trim.toLowerCase.endsWith(".exe"))
            {
                sparkclrStart(file, args)
            }
            else
            {
                super.start(file, args)
            }
        }
        
        _className match{
            case Some(className) => startProcessBaseOnClassName(className, file, args)
            case None => super.start(file, args)
        }
    }

    private def sparkclrStart(file: Path, args: Traversable[String]): SparkProcess = {
        val naoLivyConfig = livyConf.asInstanceOf[NaoLivyConf]
        _executable = AbsolutePath(naoLivyConfig.sparkclrSubmit())

        var arguments = ArrayBuffer(fromPath(_executable))

        def addOpt(option: String, value: Option[String]): Unit = {
          value.foreach { v =>
            arguments += option
            arguments += v
          }
        }

        def addList(option: String, values: Traversable[String]): Unit = {
          if (values.nonEmpty) {
            arguments += option
            arguments += values.mkString(",")
          }
        }

    

        addOpt("--master", _master)
        addOpt("--deploy-mode", _deployMode)
        addOpt("--name", _name)
        addList("--jars", _jars.map(fromPath))
        addList("--py-files", _pyFiles.map(fromPath))
        addList("--files", _files.map(fromPath))
        addOpt("--exe", _className)
        addList("--driver-class-path", _driverClassPath)

        if (livyConf.getBoolean(LivyConf.IMPERSONATION_ENABLED_KEY, true)) {
          addOpt("--proxy-user", _proxyUser)
        }

        addOpt("--queue", _queue)
        addList("--archives", _archives.map(fromPath))

        //arguments += fromPath(file)
        arguments += sparkclrExecutionPath(file)
        arguments ++= args

        val argsString = arguments
          .map("'" + _.replace("'", "\\'") + "'")
          .mkString(" ")

        info(s"Running $argsString")

        val pb = new ProcessBuilder(arguments)
        val env = pb.environment()

        for ((key, value) <- _env) {
          env.put(key, value)
        }

        _redirectOutput.foreach(pb.redirectOutput)
        _redirectError.foreach(pb.redirectError)
        _redirectErrorStream.foreach(pb.redirectErrorStream)

        SparkProcess(pb.start(), Some(argsString))
    }

    private def sparkclrExecutionPath(path: Path) = path match {
        case AbsolutePath(p) => p
        case RelativePath(p) => p
    }

}

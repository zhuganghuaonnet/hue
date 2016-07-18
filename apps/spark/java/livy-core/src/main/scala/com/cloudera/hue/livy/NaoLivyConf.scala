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

package com.cloudera.hue.livy

import java.io.File
import java.util.concurrent.ConcurrentHashMap

import scala.collection.JavaConverters._

object NaoLivyConf {
  val SPARKCLR_HOME_KEY = "livy.server.sparkclr-home"
  val SPARKCLR_SUBMIT_KEY = "livy.server.sparkclr-submit"
}

/**
 *
 * @param loadDefaults whether to also load values from the Java system properties
 */

class NaoLivyConf(loadDefaults: Boolean) extends LivyConf(loadDefaults) {

  import NaoLivyConf._

  def this() = this(true)

  /** Return the location of the sparkclr home directory */
  def sparkclrHome(): Option[String] = getOption(SPARKCLR_HOME_KEY).orElse(sys.env.get("SPARKCLR_HOME"))

  /** Return the path to the sparkclr-submit executable. */
  def sparkclrSubmit(): String = {
    getOption(SPARKCLR_SUBMIT_KEY)
      .orElse { sparkclrHome().map { _ + File.separator + "scripts" + File.separator + "sparkclr-submit.cmd" } }
      .getOrElse("sparkclr-submit.cmd")
  }

  /** Return the filesystem root. Defaults to the local filesystem. */
  def sparkclrFilesystemRoot(): String = {
    "file://"
  }
}

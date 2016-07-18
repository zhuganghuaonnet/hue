package com.cloudera.hue.livy.spark

import com.cloudera.hue.livy.LineBufferedProcess

object SparkProcess {
  def apply(process: Process, argsString: Option[String]): SparkProcess = {
    new SparkProcess(process, argsString)
  }
}

class SparkProcess(process: Process, argsString: Option[String]) extends LineBufferedProcess(process, argsString) {
}

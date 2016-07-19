package com.cloudera.hue.livy.server

import com.cloudera.hue.livy.yarn.Client
import org.apache.hadoop.yarn.api.records._
import com.cloudera.hue.livy.{LivyConf, Logging}
import com.cloudera.hue.livy.spark._
import com.fasterxml.jackson.core.JsonParseException
import org.json4s.JsonDSL._
import org.json4s._
import org.scalatra._
import org.scalatra.json.JacksonJsonSupport

object ApplicationReportServlet extends Logging

class ApplicationReportServlet(livyConf: LivyConf)
  extends ScalatraServlet
    with MethodOverride
    with JacksonJsonSupport
    with UrlGeneratorSupport {

  override protected implicit def jsonFormats: Formats = DefaultFormats

  val client = new Client(livyConf)

  before() {
    contentType = formats("json")
  }

  get("/:appId") {
    val report = client.getJobFromApplicationId(params("appId")).getApplicationReport
    serializeApplicationReport(report)
  }

  get("/:appId/originalTrackingUrl") {
    val report = client.getJobFromApplicationId(params("appId")).getApplicationReport
    ("applicationId", report.getApplicationId.toString) ~
      ("originalTrackingUrl", report.getOriginalTrackingUrl)
  }

  override def destroy() = {
    super.destroy()
    client.close()
  }

  def serializeApplicationReport(report: ApplicationReport) = {
    ("applicationId", report.getApplicationId.toString) ~
      ("attemptId", report.getCurrentApplicationAttemptId.toString) ~
      ("originalTrackingUrl", report.getOriginalTrackingUrl)
  }
}

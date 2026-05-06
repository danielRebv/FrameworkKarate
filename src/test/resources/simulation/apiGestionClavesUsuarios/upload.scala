package simulations.apiGestionClavesUsuarios

import com.intuit.karate.gatling.PreDef.{karateFeature, karateProtocol, pauseFor}
import io.gatling.core.Predef.{Simulation, configuration, constantUsersPerSec, csv, global, openInjectionProfileFactory, scenario}

import scala.concurrent.duration.DurationInt
import scala.language.postfixOps

class Update extends Simulation{
  val feed = csv("data/performance/apiGestionClavesUsuarios/upload.csv").circular();

  val postSimulationTarjetas = scenario("pago tarjetas")
    .feed(feed)
    .exec(karateFeature("classpath:features/integracion/apiGestionClaves/update.feature@peformance=update_auth"));

  val protocol = karateProtocol(
    "/feature" -> pauseFor( "post" -> 0)
  )

  protocol.runner.karateEnv("perf");

  setUp(
    postSimulationTarjetas.inject(
      //constantUsersPerSec(1) during (10 seconds),
      constantUsersPerSec(1) during (6 minutes),
      //constantUsersPerSec(2) during (2 minutes),
      //constantUsersPerSec(1) during (2 minutes),
    ).protocols(protocol)
  ).assertions(
    global.responseTime.percentile(95).lt(1000),
    global.failedRequests.percent.lt(1) )
}
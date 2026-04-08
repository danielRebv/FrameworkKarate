package runners;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.AfterAll;
import utils.ExtentReportAdapter;
class TestRunner {
    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:features").outputCucumberJson(true);
    }
    @AfterAll
    static void generateExtentReport() throws Exception {
        //System.out.println("ejecutando reporte ");
        ExtentReportAdapter.generateReport();
    }
}
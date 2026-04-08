package utils;

import com.aventstack.extentreports.*;

import com.aventstack.extentreports.reporter.ExtentSparkReporter;

import com.fasterxml.jackson.databind.JsonNode;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;

import java.util.Base64;

public class ExtentReportAdapter {

    public static void generateReport() throws Exception {

        ExtentSparkReporter spark = new ExtentSparkReporter("build/extent-report.html");
        spark.config().setReportName("Karate API Report");
        ExtentReports extent = new ExtentReports();
        extent.attachReporter(spark);
        ObjectMapper mapper = new ObjectMapper();



        File dir = new File("build/reports/karate");

        if (!dir.exists()) {

            dir = new File("build/karate-reports");

        }

        //System.out.println("📁 Leyendo reportes desde: " + dir.getAbsolutePath());

        if (!dir.exists()) {

            //System.out.println("❌ No existe carpeta de reportes");

            return;

        }

        File[] files = dir.listFiles((d, name) -> name.endsWith(".json"));

        if (files == null || files.length == 0) {

           // System.out.println("❌ No hay archivos JSON");

            return;

        }

        //System.out.println("✅ JSON encontrados: " + files.length);

        for (File file : files) {

            //System.out.println("📄 Procesando: " + file.getName());

            JsonNode rootArray = mapper.readTree(file);

            if (!rootArray.isArray()) {

               // System.out.println("⚠️ JSON no es array: " + file.getName());

                continue;

            }

            for (JsonNode root : rootArray) {

                String featureName = getSafe(root, "name");

                ExtentTest feature = extent.createTest("📌 " + featureName);

                JsonNode elements = root.get("elements");

                if (elements == null || !elements.isArray()) {

                    continue;

                }

                for (JsonNode scenario : elements) {

                    String scenarioName = getSafe(scenario, "name");

                    ExtentTest test = feature.createNode("🧪 " + scenarioName);

                    JsonNode steps = scenario.get("steps");

                    if (steps == null || !steps.isArray()) {

                        continue;

                    }

                    for (JsonNode step : steps) {

                        String keyword = getSafe(step, "keyword").trim();
                        String name = getSafe(step, "name");

                        String coloredKeyword = keyword;
                        if (keyword.equalsIgnoreCase("Given")) {
                            coloredKeyword = "<span style='color:#f9a825; font-weight:bold'>" + keyword + "</span>";
                        } else if (keyword.equalsIgnoreCase("When")) {
                            coloredKeyword = "<span style='color:#1565c0; font-weight:bold'>" + keyword + "</span>";
                        } else if (keyword.equalsIgnoreCase("Then")) {
                            coloredKeyword = "<span style='color:#2e7d32; font-weight:bold'>" + keyword + "</span>";
                        } else if (keyword.equalsIgnoreCase("And")) {
                            coloredKeyword = "<span style='color:#6a1b9a; font-weight:bold'>" + keyword + "</span>";
                        }

                        String stepName = (coloredKeyword + " " + name).trim();

                        JsonNode result = step.get("result");

                        String status = getSafe(result, "status");

                        String errorMessage = getSafe(result, "error_message");

                        String details = buildDetails(step);

                        if ("passed".equalsIgnoreCase(status)) {

                            test.pass(stepName + details);

                        } else if ("failed".equalsIgnoreCase(status)) {

                            test.fail("❌ " + stepName

                                    + formatError(errorMessage, result)

                                    + details);

                        } else {

                            test.info(stepName + details);

                        }

                    }

                }

            }

        }

        extent.flush();

        //System.out.println("✅ Extent report generado: build/extent-report.html");

    }



    private static String getSafe(JsonNode node, String field) {

        if (node == null || node.get(field) == null) return "";

        return node.get(field).asText();

    }



    private static String formatError(String errorMessage, JsonNode result) {

        StringBuilder sb = new StringBuilder();

        if (errorMessage != null && !errorMessage.isEmpty()) {

            sb.append("<br><b style='color:red'>Error:</b><pre>")

                    .append(errorMessage)

                    .append("</pre>");

        }

        if (result != null) {

            sb.append("<br><b>Detalle:</b><pre>")

                    .append(result.toPrettyString())

                    .append("</pre>");

        }

        return sb.toString();

    }


    private static String buildDetails(JsonNode step) {

        StringBuilder sb = new StringBuilder();

        JsonNode embeddings = step.get("embeddings");

        if (embeddings != null && embeddings.isArray()) {

            int index = 0;

            for (JsonNode embed : embeddings) {

                if (embed.get("data") != null) {

                    String base64 = embed.get("data").asText();

                    try {

                        String decoded = new String(Base64.getDecoder().decode(base64));

                        if (index == 0) {

                            sb.append("<br><b style='color:blue'>Request:</b><pre>")

                                    .append(decoded)

                                    .append("</pre>");

                        } else {

                            sb.append("<br><b style='color:green'>Response:</b><pre>")

                                    .append(decoded)

                                    .append("</pre>");

                        }

                        index++;

                    } catch (Exception e) {

                        sb.append("<br><b>Data (raw):</b>").append(base64);

                    }

                }

            }

        }

        return sb.toString();

    }


}

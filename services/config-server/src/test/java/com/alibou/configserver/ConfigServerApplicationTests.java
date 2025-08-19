package com.alibou.configserver;

import com.alibou.configserver.testutil.ConfigAssertService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.CoreMatchers.containsString;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("native")
class ConfigServerApplicationTests {
    @Autowired
    MockMvc mvc;
    @Autowired
    ConfigAssertService cfgAssert;



    @Test
    void contextLoads() {
    }

//    @Test
//    void servesGatewayConfig() throws Exception {
//        mvc.perform(get("/gateway-service/default"))
//                .andExpect(status().isOk())
//                .andExpect(content().contentType("application/json"))
//                // Ověří, že se v JSONu nachází property eureka.client.service-url.defaultZone
//                .andExpect(jsonPath("$.propertySources[0].source['eureka.client.service-url.defaultZone']")
//                        .value("http://discovery-service.default.svc.cluster.local:8761/eureka"))
//                .andExpect(jsonPath("$.name").value("gateway-service"))
//                .andExpect(jsonPath("$.profiles[0]").value("default"))
//                .andExpect(jsonPath("$.propertySources").isArray())
//                .andExpect(jsonPath("$.propertySources.length()").value(org.hamcrest.Matchers.greaterThan(0)));

    @Test
    void servesGatewayConfig() throws Exception {
        cfgAssert.assertConfig(
                mvc,
                "gateway-service",
                "http://discovery-service.default.svc.cluster.local:8761/eureka"
        );
    }

    @Test
    void servesCustomerConfig() throws Exception {
        // tady defaultZone třeba neřeším
        cfgAssert.assertConfig(mvc, "customer-service", null);
    }


    @ParameterizedTest
    @ValueSource(strings = {"gateway-service", "customer-service", "order-service"})
    void servesConfigs(String app) throws Exception {
        cfgAssert.assertConfig(mvc, app, null);
    }






}

package com.alibou.configserver.testutil;

import org.hamcrest.Matchers;
import org.springframework.stereotype.Component;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Component
public class ConfigAssertService {

    /**
     * Ověří, že config-server vrací JSON pro danou službu a profil "default".
     * @param mvc MockMvc z tvého testu
     * @param appName název aplikace (soubor v configurations, např. "gateway-service")
     * @param expectedDefaultZone může být null -> aserce se přeskočí
     */
    public void assertConfig(MockMvc mvc, String appName, String expectedDefaultZone) throws Exception {
        var req = get("/" + appName + "/default");

        var resultActions = mvc.perform(req)
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(jsonPath("$.name").value(appName))
                .andExpect(jsonPath("$.profiles[0]").value("default"))
                .andExpect(jsonPath("$.propertySources").isArray())
                .andExpect(jsonPath("$.propertySources.length()").value(Matchers.greaterThan(0)));

        if (expectedDefaultZone != null && !expectedDefaultZone.isBlank()) {
            resultActions.andExpect(
                    jsonPath("$.propertySources[0].source['eureka.client.service-url.defaultZone']")
                            .value(expectedDefaultZone)
            );
        }
    }
}

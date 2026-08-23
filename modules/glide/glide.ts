// Remember betterfox is included by default
// https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/browserSettings

// Extensions
{
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi");
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi");
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/proton-vpn-firefox-extension/latest.xpi");
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi");
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi");
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/enhancer-for-youtube/latest.xpi");
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi");
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/tabliss/latest.xpi");
    glide.addons.install("https://addons.mozilla.org/firefox/downloads/latest/matte-black-v1/latest.xpi").then(async (theme) => {
        await browser.management.setEnabled(theme.id, true);
    });
}

// Toolbar
{
    glide.prefs.set("browser.uidensity", 1);

    glide.styles.add(`
        :root {
            /* Make the margin around the tab buttons smaller */
            --tab-inner-inline-margin: 4px !important;
            /* Removes the dimming when you hover off firefox */
            --inactive-titlebar-opacity: 1 !important;
        }
        /* Make the sidebar thinner */
        #sidebar-container:has(> sidebar-main:not([expanded])) {
            width: var(--tab-collapsed-width) !important;
        }
        #sidebar-button {
            translate: -4px 0;
        }

        /* Remove the settings button, could only really do this by removing everything
        other than the tabs */
        sidebar-main {
            visibility: hidden !important;
        }
        sidebar-main > #vertical-tabs {
            visibility: visible !important;
        }

        /* Hide some toolbar buttons */
        #firefox-view-button,
        #alltabs-button,
        .titlebar-close {
            display: none !important;
        }
    `, { id: "hide-toolbar-buttons", overwrite: true });
}

// Generic Settings
{
    // Change the hint size when you press "f"
    glide.o.hint_size = "20px";
}

// Tab behaviour
{
    glide.prefs.set("sidebar.main.tools", "");

    glide.keymaps.set(["normal", "insert"], "<A-e>", "tab_next");
    glide.keymaps.set(["normal", "insert"], "<A-q>", "tab_prev");
    glide.keymaps.set(["normal", "insert"], "<A-w>", "tab_new");
    glide.keymaps.set(["normal", "insert"], "<A-a>", "tab_close");
    glide.keymaps.set(["normal", "insert"], "<A-d>", "tab_duplicate");

    glide.autocmds.create("ConfigLoaded", async () => {
        await browser.browserSettings.verticalTabs.set({ value: true });

        if (document.querySelector("sidebar-main")?.hasAttribute("expanded")) {
            await glide.keys.send("<C-A-z>", { skip_mappings: true });
        }
    });

    // Focus search bar (and set mode to insert)
    glide.keymaps.set(["normal", "insert"], "<A-s>", async () => {
        await glide.keys.send("<C-l>");
        await glide.excmds.execute("mode_change insert");
    });

    glide.search_engines.add({
        name: "DuckDuckGo",
        keyword: ["duckduckgo", "ddg"],
        search_url: "https://duckduckgo.com/?q={searchTerms}",
        suggest_url: "https://ac.duckduckgo.com/ac/?q={searchTerms}&type=list",
        is_default: true,
    });
}

// Bookmarks
{
    // Open the bookmarks sidebar
    glide.keymaps.set(["normal", "insert"], "<A-x>", async () => {
        await glide.keys.send("<C-b>", { skip_mappings: true });
    });

    // Hide the top bookmark bar
    glide.prefs.set("browser.toolbars.bookmarks.visibility", "never");
    glide.autocmds.create("ConfigLoaded", async () => {
        // if (document.querySelector("#PersonalToolbar")?.getAttribute("collapsed") === "false") {
        //     await glide.keys.send("<C-S-b>", { skip_mappings: true });
        // }
    });
}

// Smooth Scrolling
{
    // Smooth scrolling https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
    glide.prefs.set("apz.overscroll.enabled", true);
    glide.prefs.set("general.smoothScroll", true);
    glide.prefs.set("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
    glide.prefs.set("general.smoothScroll.msdPhysics.enabled", true);
    glide.prefs.set("general.smoothScroll.currentVelocityWeighting", "0.15");
    glide.prefs.set("general.smoothScroll.stopDecelerationWeighting", "0.6");
    glide.prefs.set("mousewheel.min_line_scroll_amount", 10);
    glide.prefs.set("general.smoothScroll.mouseWheel.durationMinMS", 80);
    glide.prefs.set("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
    glide.prefs.set("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
    glide.prefs.set("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
    glide.prefs.set("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", "2");
    glide.prefs.set("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
    glide.prefs.set("mousewheel.default.delta_multiplier_y", 275);
}

// Cookie Whitelist
{
    const cookieWhitelist = ["github.com", "youtube.com", "sable.moe", "chatgpt.com", "openai.com",  "proton.me", "claude.com"];
    async function makeCookieSessionOnly(cookie: Browser.Cookies.Cookie) {
        // Already a session only cookie
        if (cookie.session) {
            return;
        }

        // https://searchfox.org/firefox-main/source/toolkit/components/extensions/parent/ext-cookies.js#246-254
        // Firefox explicitly appends a leading . to cookies that supply an explicit domain, so we strip them
        // (I believe they do this, so they can see if the domain is host-only (ie. only sent to that specific domain,
        // which a leading . would indicate)
        const domain = cookie.domain.replace(/^\./, "");
        // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some
        if (cookieWhitelist.some((whitelisted) => {
            // Also check if it's a subdomain
            return domain === whitelisted || domain.endsWith(`.${whitelisted}`);
        })) {
            return;
        };

        // Don't set the expirationDate, omitting it makes it a session cookie
        await browser.cookies.set({
            url: `${cookie.secure ? "https" : "http"}://${domain}${cookie.path}`,
            name: cookie.name,
            value: cookie.value,
            path: cookie.path,
            secure: cookie.secure,
            httpOnly: cookie.httpOnly,
            sameSite: cookie.sameSite,
            storeId: cookie.storeId,
            ...(!cookie.hostOnly && { domain: cookie.domain }),
            ...(cookie.firstPartyDomain && { firstPartyDomain: cookie.firstPartyDomain }),
            ...(cookie.partitionKey && { partitionKey: cookie.partitionKey }),
        });
    }

    browser.cookies.onChanged.addListener(({ removed, cookie }) => {
        if (!removed) {
            void makeCookieSessionOnly(cookie).catch(console.error);
        }
    });

    glide.prefs.set("privacy.clearOnShutdown_v2.cookiesAndStorage", false);

    // Clear Browsing Data on Shutdown
    glide.prefs.set("privacy.sanitize.sanitizeOnShutdown", true);
    glide.prefs.set("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", true);
    glide.prefs.set("privacy.clearOnShutdown_v2.cache", true);
    glide.prefs.set("privacy.clearOnShutdown_v2.formdata", true);
    glide.prefs.set("privacy.clearOnShutdown_v2.offlineApps", true);
    glide.prefs.set("privacy.clearOnShutdown_v2.sessions", true);
    glide.prefs.set("privacy.clearOnShutdown_v2.siteSettings", true);

    glide.prefs.set("browser.sessionstore.privacy_level", 2);

    glide.autocmds.create("ConfigLoaded", async () => {
        const cookies = await browser.cookies.getAll({ partitionKey: {} });
        await Promise.all(cookies.map(makeCookieSessionOnly));
    });
}

console.log("🟢 Shopify OAuth Callback (Deno 2) loaded");

Deno.serve(async (req: Request): Promise<Response> => {
  console.info("🚀 Callback triggered");

  const url = new URL(req.url);
  let shop = url.searchParams.get("shop");
  let code = url.searchParams.get("code");

  // ✅ Allow testing via POST (Supabase dashboard, curl, etc.)
  if (req.method === "POST") {
    try {
      const body = await req.json();
      shop = shop || body.shop;
      code = code || body.code;
    } catch (err) {
      console.warn("⚠️ Could not parse POST body:", err);
    }
  }

  if (!shop || !code) {
    console.warn("❌ Missing shop or code");
    return new Response(JSON.stringify({ error: "Missing shop or code" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  // ✅ Load secrets
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRole = Deno.env.get("SERVICE_ROLE_KEY"); // use your custom key
  const shopifyClientId = Deno.env.get("SHOPIFY_CLIENT_ID");
  const shopifyClientSecret = Deno.env.get("SHOPIFY_CLIENT_SECRET");

  // 🔍 Log secret health
  console.log("🔍 SUPABASE_URL:", supabaseUrl);
  console.log("🔍 SERVICE_ROLE_KEY present:", !!serviceRole, "| length:", (serviceRole || "").length);
  console.log("🔍 SHOPIFY_CLIENT_ID present:", !!shopifyClientId);
  console.log("🔍 SHOPIFY_CLIENT_SECRET present:", !!shopifyClientSecret);

  if (!supabaseUrl || !serviceRole || !shopifyClientId || !shopifyClientSecret) {
    console.error("❌ Missing one or more environment variables");
    return new Response("Missing environment variables", { status: 500 });
  }

  console.info(`🛒 Shop: ${shop}`);
  console.info("🔁 Exchanging code for Shopify access token...");

  const tokenRes = await fetch(`https://${shop}/admin/oauth/access_token`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      client_id: shopifyClientId,
      client_secret: shopifyClientSecret,
      code
    })
  });

  if (!tokenRes.ok) {
    const error = await tokenRes.text();
    console.error("❌ Token exchange failed:", error);
    return new Response("Token exchange failed", { status: 500 });
  }

  const tokenData = await tokenRes.json();
  const accessToken = tokenData.access_token;

  console.log("✅ Access token received from Shopify:", accessToken ? "✔️ yes" : "❌ no");

  const headers = {
    Authorization: `Bearer ${serviceRole}`,
    apikey: serviceRole,
    "Content-Type": "application/json",
    Prefer: "resolution=merge-duplicates"
  };

  console.log("📦 Supabase request headers:");
  console.log("🔑 Authorization:", headers.Authorization);
  console.log("🔑 apikey:", headers.apikey);

  const supabaseRes = await fetch(`${supabaseUrl}/rest/v1/shops`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      user_id: "anonymous",
      shop_domain: shop,
      access_token: accessToken
    }),
  });

  if (!supabaseRes.ok) {
    const error = await supabaseRes.text();
    console.error("❌ Supabase insert failed:", error);
    return new Response("Failed to upsert shop", { status: 500 });
  }

  console.info(`✅ Shop ${shop} inserted successfully`);
  console.info("➡️ Redirecting to DropFlow dashboard");

  return Response.redirect("https://splitmind.app/dropflow", 302);
});

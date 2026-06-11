-- ============================================================
--  MAVEN FUZZY FACTORY | SQL GROWTH ANALYSIS
--  Author   : Logan Kirby
--  Tool     : MySQL
--  Course   : Advanced SQL | Ecommerce Data Analysis (Maven Analytics / Udemy)
--  Role     : Database Analyst (simulated)
-- ============================================================

/*
╔══════════════════════════════════════════════════════════════╗
║                     PROJECT OVERVIEW                        ║
╚══════════════════════════════════════════════════════════════╝

   In this project I'm tasked with analyzing business performance from
   launch through the most recent quarter and build a
   data driven growth story for potential investors.

   Results uncovered:
   ─────────────────────────────────────────────────────────────
   ▸ Session and order volume grew consistently quarter over
     quarter.

   ▸ Efficiency metrics including CVR, revenue per order, revenue per
     session, all improved over time.

   ▸ All traffic channels grew over time and became more efficient, signaling
     rising brand awareness and lower dependence on paid spend.

   ▸ New product launches diversified revenue and boosted
     overall profit margins.

   ▸ Landing page and product page optimizations lifted
     click through rates and order conversion rates.

   ▸ The cross-sell analysis after the 4th product launch revealed
     actionable upsell opportunities to increase average order
     value.

   DATABASE TABLES USED:
   ─────────────────────────────────────────────────────────────
   ▸ website_sessions   — one row per user session, includes
                          traffic source / UTM data
   ▸ website_pageviews  — one row per page viewed per session
   ▸ orders             — one row per completed order
   ▸ order_items        — one row per product within an order
*/


-- ============================================================
--  QUESTION 1 | Overall Session & Order Volume Growth
--              Trended by Quarter
-- ============================================================

/*
   WHY THIS MATTERS
   ─────────────────────────────────────────────────────────────
   The first thing an investor wants to see is raw growth.
   By pulling total web sessions and orders for every
   quarter since launch, we demonstrate that the Fuzzy
   Factory has consistently scaled in reach and revenue.

   Note: the most recent quarter is incomplete and should be
   read as a partial period.

   FINDING
   ─────────────────────────────────────────────────────────────
   Both session volume and order counts grew quarter over
   quarter throughout the life of the business, confirming
   that the company successfully expanded its audience while
   converting visitors into paying customers.
   * Note: the most recent quarter is incomplete and should be
   read as a partial period.
*/

SELECT
    YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
    MAX(DATE(ws.created_at)) AS final_date_that_quarter,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions ws
    LEFT JOIN orders o
        ON ws.website_session_id = o.website_session_id
GROUP BY 1, 2;


-- ============================================================
--  QUESTION 2 | Efficiency Improvements by Quarter
--              CVR, Revenue per Order & Revenue per Session
-- ============================================================

/*
   WHY THIS MATTERS
   ─────────────────────────────────────────────────────────────
   Volume growth alone is not all that matters, what matters is whether the business is getting
   more efficient over time. Here we track three key metrics:

   ▸ Session to Order CVR    
   ▸ Revenue per Order         
   ▸ Revenue per Session       

   All three metrics improving means the business is
   optimizing it's inflow of traffic.

   FINDING
   ─────────────────────────────────────────────────────────────
   All three metrics trended upward over the life of the
   business. Rising CVR reflects landing page testing and
   better traffic targeting. Rising revenue per order points
   to the impact of new product launches and cross-selling.
*/

SELECT
    YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
    MAX(DATE(ws.created_at)) AS final_date_that_quarter,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT ws.website_session_id)
    * 100, 2) AS session_order_cvr,
    ROUND(
        SUM(o.price_usd)
        / COUNT(DISTINCT o.order_id)
    , 2) AS rev_per_order,
    ROUND(
        SUM(o.price_usd)
        / COUNT(DISTINCT ws.website_session_id)
    , 2) AS rev_per_session
FROM website_sessions ws
    LEFT JOIN orders o
        ON ws.website_session_id = o.website_session_id
GROUP BY 1, 2;


-- ============================================================
--  QUESTION 3 | Orders by Traffic Channel, by Quarter
-- ============================================================

/*
   WHY THIS MATTERS
   ─────────────────────────────────────────────────────────────
   Understanding where orders come from is critical for
   evaluating marketing costs and channel insights. 
   There are five acquisition channels each quarter:

   ▸ gsearch nonbrand   — paid Google search
   ▸ bsearch nonbrand   — paid Bing search
   ▸ brand search       — paid search on brand name keywords
   ▸ organic search 
   ▸ direct type-in

   FINDING
   ─────────────────────────────────────────────────────────────
   gsearch nonbrand was the dominant order driver throughout.
   Over time, organic search and direct type-in orders grew
   steadily. This reduces dependence on paid channels and lowers the
   cost of acquiring each new customer.
*/

SELECT
    YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
    MAX(DATE(ws.created_at)) AS final_date_that_quarter,
    COUNT(DISTINCT CASE
        WHEN http_referer IS NULL
        THEN o.order_id END) AS direct_type_in_orders,
    COUNT(DISTINCT CASE
        WHEN utm_source IS NULL
        AND http_referer IN (
            'https://www.gsearch.com',
            'https://www.bsearch.com')
        THEN o.order_id END) AS organic_search_orders,
    COUNT(DISTINCT CASE
        WHEN utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
        THEN o.order_id END) AS gsearch_nonbrand_orders,
    COUNT(DISTINCT CASE
        WHEN utm_source = 'bsearch'
        AND utm_campaign = 'nonbrand'
        THEN o.order_id END) AS bsearch_nonbrand_orders,
    COUNT(DISTINCT CASE
        WHEN utm_campaign = 'brand'
        THEN o.order_id END) AS brand_search_orders
FROM website_sessions ws
    LEFT JOIN orders o
        ON ws.website_session_id = o.website_session_id
GROUP BY 1, 2;


-- ============================================================
--  QUESTION 4 | Session to Order CVR by Channel, per Quarter
-- ============================================================

/*
   WHY THIS MATTERS
   ─────────────────────────────────────────────────────────────
   A channel with improving CVR over time signals better targeting, stronger landing pages,
   and greater traffic with inent reaching the site.

   This analysis lets us identify which periods saw major
   improvements and connect them to specific optimizations
   made by the marketing and web teams.

   FINDING
   ─────────────────────────────────────────────────────────────
   CVR improved across all channels over the life of the
   business. Paid channels (gsearch and bsearch nonbrand)
   showed notable lifts following landing page tests and
   bid optimizations. Direct and organic channels, which
   attract higher-intent users, maintained strong CVRs
   throughout.
*/

SELECT
    YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
    MAX(DATE(ws.created_at)) AS final_date_that_quarter,
    ROUND(
        COUNT(DISTINCT CASE WHEN http_referer IS NULL
            THEN o.order_id END)
        / NULLIF(COUNT(DISTINCT CASE WHEN http_referer IS NULL
            THEN ws.website_session_id END), 0)
    * 100, 2) AS direct_type_in_cvr,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN utm_source IS NULL
            AND http_referer IN (
                'https://www.gsearch.com',
                'https://www.bsearch.com')
            THEN o.order_id END)
        / NULLIF(COUNT(DISTINCT CASE
            WHEN utm_source IS NULL
            AND http_referer IN (
                'https://www.gsearch.com',
                'https://www.bsearch.com')
            THEN ws.website_session_id END), 0)
    * 100, 2) AS organic_search_cvr,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN utm_source = 'gsearch'
            AND utm_campaign = 'nonbrand'
            THEN o.order_id END)
        / NULLIF(COUNT(DISTINCT CASE
            WHEN utm_source = 'gsearch'
            AND utm_campaign = 'nonbrand'
            THEN ws.website_session_id END), 0)
    * 100, 2)  AS gsearch_nonbrand_cvr,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN utm_source = 'bsearch'
            AND utm_campaign = 'nonbrand'
            THEN o.order_id END)
        / NULLIF(COUNT(DISTINCT CASE
            WHEN utm_source = 'bsearch'
            AND utm_campaign = 'nonbrand'
            THEN ws.website_session_id END), 0)
    * 100, 2) AS bsearch_nonbrand_cvr,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN utm_campaign = 'brand'
            THEN o.order_id END)
        / NULLIF(COUNT(DISTINCT CASE
            WHEN utm_campaign = 'brand'
            THEN ws.website_session_id END), 0)
    * 100, 2) AS brand_search_cvr
FROM website_sessions ws
    LEFT JOIN orders o
        ON ws.website_session_id = o.website_session_id
GROUP BY 1, 2;


-- ============================================================
--  QUESTION 5 | Monthly Revenue & Profit Margin by Product
-- ============================================================

/*
   WHY THIS MATTERS
   ─────────────────────────────────────────────────────────────
   The Fuzzy Factory launched with a single product and
   expanded its catalog over time. Tracking monthly revenue
   and profit margin by product reveals:

   ▸ When each product was introduced and became a revenue contributor
   ▸ How the product mix diversified total revenue streams
   ▸ How the overall margin held up as the catalog grew

   PRODUCTS:
   ▸ Product 1 — Original Fuzzy Bear
   ▸ Product 2 — Love Bear
   ▸ Product 3 — Sugar Panda
   ▸ Product 4 — Hudson River Bear

   FINDING
   ─────────────────────────────────────────────────────────────
   The Original Fuzzy Bear carried all revenue in the early
   months. Each new product launch added incremental revenue
   and margin, and total revenue grew substantially as the
   catalog expanded. A multi-product catalog reduces
   business risk by diversifying the revenue base.
*/

SELECT
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    SUM(CASE WHEN product_id = 1
        THEN price_usd END) AS fuzzy_bear_rev,
    SUM(CASE WHEN product_id = 1
        THEN price_usd END)
    - SUM(CASE WHEN product_id = 1
        THEN cogs_usd END) AS fuzzy_bear_margin,
    SUM(CASE WHEN product_id = 2
        THEN price_usd END) AS love_bear_rev,
    SUM(CASE WHEN product_id = 2
        THEN price_usd END)
    - SUM(CASE WHEN product_id = 2
        THEN cogs_usd END) AS love_bear_margin,
    SUM(CASE WHEN product_id = 3
        THEN price_usd END) AS sugar_panda_rev,
    SUM(CASE WHEN product_id = 3
        THEN price_usd END)
    - SUM(CASE WHEN product_id = 3
        THEN cogs_usd END) AS sugar_panda_margin,
    SUM(CASE WHEN product_id = 4
        THEN price_usd END) AS hudson_river_bear_rev,
    SUM(CASE WHEN product_id = 4
        THEN price_usd END)
    - SUM(CASE WHEN product_id = 4
        THEN cogs_usd END) AS hudson_river_bear_margin,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd) - SUM(cogs_usd) AS total_profit_margin
FROM order_items
GROUP BY 1, 2;


-- ============================================================
--  QUESTION 6 | Product Page Click-Through & Conversion Rate
--              Monthly Trend
-- ============================================================

/*
   WHY THIS MATTERS
   ─────────────────────────────────────────────────────────────
   The /products page is an important point in the overall purchase
   funnel in the website. Users who show have landed on that page are showing intent to buy,
   but the question is whether the page successfully converts.

   We track two metrics monthly:
   ▸ Click-Through Rate (CTR)       
   ▸ Product-to-Order Conversion Rate

   APPROACH
   ─────────────────────────────────────────────────────────────
   Two CTEs are used:
   ▸ product_page    — identifies each session's visit to
                       /products and records its pageview ID
   ▸ following_page  — finds the next pageview in that session
                       after the /products page visit

   FINDING
   ─────────────────────────────────────────────────────────────
   Both CTR and product-to-order conversion rate improved over
   time. New product launches gave visitors more to engage
   with, and the navigation optimizations made it
   easier for users to move from browsing to buying.
*/

WITH product_page AS (
    SELECT
        website_session_id,
        MIN(website_pageview_id) AS product_page_id,
        created_at
    FROM website_pageviews
    WHERE pageview_url = '/products'
    GROUP BY 1
),
following_page AS (
    SELECT
        pp.website_session_id,
        pp.product_page_id,
        pp.created_at AS product_page_created_at,
        MIN(wpv.website_pageview_id) AS following_page_id,
        wpv.created_at AS following_page_created_at
    FROM product_page pp
        LEFT JOIN website_pageviews wpv
            ON pp.website_session_id = wpv.website_session_id
            AND pp.product_page_id < wpv.website_pageview_id
    GROUP BY 1
)
SELECT
    YEAR(fp.product_page_created_at) AS year,
    MONTH(fp.product_page_created_at) AS month,
    COUNT(DISTINCT fp.product_page_id) AS product_page_sessions,
    ROUND(
        COUNT(DISTINCT fp.following_page_id)
        / COUNT(DISTINCT fp.product_page_id)
    * 100, 2) AS product_page_ctr,
    ROUND(
        COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT fp.product_page_id)
    * 100, 2) AS product_to_order_conv_rt
FROM following_page fp
    LEFT JOIN orders o
        ON fp.website_session_id = o.website_session_id
GROUP BY 1, 2;


-- ============================================================
--  QUESTION 7 | Cross-Sell Analysis After 4th Product Launch
-- ============================================================

/*
   WHY THIS MATTERS
   ─────────────────────────────────────────────────────────────
   With four products in the catalog, the company gained the
   opportunity to drive cross-selling.

   The analysis looks at every order placed after the 4th product, the Hudson
   River Bear, launched on December 5, 2014. Then measures the
   rate at which each primary product cross-sold to every
   other product in the catalog.

   APPROACH
   ─────────────────────────────────────────────────────────────
   Two CTEs are used:
   ▸ primary_product      — identifies the primary item in
                            each post launch order
   ▸ cross_sell_products  — joins non primary order items to
                            find what was added alongside the primary item

   is_primary_item = 0 flags any item that was added as a
   cross-sell / secondary product in the order.

   FINDING
   ─────────────────────────────────────────────────────────────
   Cross-sell rates varied meaningfully by primary product,
   revealing which product pairings were most popular with
   customers. This insight is directly actionable enabling
   the team to optimize upsell prompts and increase average
   order value without needing additional traffic spend.
*/

WITH primary_product AS (
    SELECT
        order_id,
        primary_product_id,
        created_at
    FROM orders
    WHERE created_at > '2014-12-05'
),
cross_sell_products AS (
    SELECT
        pp.order_id,
        pp.primary_product_id,
        pp.created_at,
        oi.product_id AS cross_sell_product
    FROM primary_product pp
        LEFT JOIN order_items oi
            ON pp.order_id = oi.order_id
            AND oi.is_primary_item = 0
)
SELECT
    csp.primary_product_id,
    COUNT(DISTINCT csp.order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN csp.cross_sell_product = 1
        THEN csp.order_id END) AS cross_sell_p1,
    ROUND(COUNT(DISTINCT CASE WHEN csp.cross_sell_product = 1
        THEN csp.order_id END)
        / COUNT(DISTINCT csp.order_id) * 100, 2) AS cross_sell_p1_rate,
    COUNT(DISTINCT CASE WHEN csp.cross_sell_product = 2
        THEN csp.order_id END) AS cross_sell_p2,
    ROUND(COUNT(DISTINCT CASE WHEN csp.cross_sell_product = 2
        THEN csp.order_id END)
        / COUNT(DISTINCT csp.order_id) * 100, 2) AS cross_sell_p2_rate,
    COUNT(DISTINCT CASE WHEN csp.cross_sell_product = 3
        THEN csp.order_id END) AS cross_sell_p3,
    ROUND(COUNT(DISTINCT CASE WHEN csp.cross_sell_product = 3
        THEN csp.order_id END)
        / COUNT(DISTINCT csp.order_id) * 100, 2) AS cross_sell_p3_rate,
    COUNT(DISTINCT CASE WHEN csp.cross_sell_product = 4
        THEN csp.order_id END) AS cross_sell_p4,
    ROUND(COUNT(DISTINCT CASE WHEN csp.cross_sell_product = 4
        THEN csp.order_id END)
        / COUNT(DISTINCT csp.order_id) * 100, 2) AS cross_sell_p4_rate
FROM cross_sell_products csp
GROUP BY 1;


-- ============================================================
--  SUMMARY | The Investor Story
-- ============================================================

/*
   Across the analysis the data tells a clear growth story for Maven Fuzzy Factory:

   ┌─────────────────────────────┬──────────────────────────────────────────┐
   │ THEME                       │ EVIDENCE                                 │
   ├─────────────────────────────┼──────────────────────────────────────────┤
   │ Sustained growth            │ Sessions and orders rose every quarter   │
   │ Improving efficiency        │ CVR, rev/order, rev/session all up       │
   │ Diversified acquisition     │ Organic and direct channels grew         │
   │ Product expansion paid off  │ Each launch added revenue and margin     │
   │ Website optimization works  │ Product page CTR and CVR improved        │
   │ Cross-sell opportunity      │ Actionable upsell pairings identified    │
   └─────────────────────────────┴──────────────────────────────────────────┘

   The business entered its most recent period with a stronger conversions,
   a broader product catalog, a more diversified traffic mix, 
   and clear opportunities for continued optimization.

   ─────────────────────────────────────────────────────────────
   Course  : Advanced SQL + MySQL for Analytics & BI
   Platform: Maven Analytics / Udemy
   Data    : Custom fictional eCommerce database (educational)
   ─────────────────────────────────────────────────────────────
*/

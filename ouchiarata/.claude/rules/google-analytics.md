---
description: Google Analytics実装、Cookie同意、analytics_storage/ad_storage設定を扱うとき
alwaysApply: false
---

# Google Analytics

1. MUST ask about cookie usage and send a consent signal upon agreement
2. `analytics_storage` MUST always be `granted` (basic analytics are always enabled)
3. `ad_storage`, `ad_user_data`, `ad_personalization` SHOULD be `granted` by default
4. IF user selects "Do not consent" -> MUST update advertising-related values to `denied`

# Archeio
API Docs:
http://ec2-3-87-173-80.compute-1.amazonaws.com/docs/api-reference.html

Notes:
Should be replicated.
Value should either be single source like cosmic eggs where we know the value or contain diversified view with minimum if 3 data points and throw out anything that is far from mean. My guess is we take uniswap, serum and binance or bitfinex aka 1. DeFi 2. Solana DeFi 3. Centralized exchange.

Pre-listing
1. User pays minor fee to create entry - should probably in native token
2. User sends collateral to keep listing active to account.

Entry information
1. Icon - specified by some sort rules (inherit the ones solana outlines maybe) *not required
2. Name *required
3. Token ticker *required
4. Normalized version (single source of truth) *not required - we need to deal with this later... especially with more ported assets
5. Mint address (if applicable) *required (not changeable)
6. Mint State (active / inactive) this is a lookup (should be updated status and immutable)
7. Circulating supply this is a lookup (needs to be stored historically)
8. Value method (need to define these as common paths) *not required
9. Historical information (we need both account value and circulating supply) per epoch
10. Wallet creating entry *required (passed from creation process)
11. Collateral posted *required (need to figure out what # to enforce... i want to enforce on parent)
12. Project url *required
13. Listed locations *not required (perhaps dressing option later and can be done via consensus)
14. Base borrow rate - calculated (this will probably come from us)
15. Base lend rate - calculated (this will probably come from us)
16. Tags - we should provide suggested list... maybe from solana project categories to begin (https://solana.com/ecosystem)

Defining required fields - though note if parentage entry provided first many other entries can be skipped.

17. Parentage (this won't contain many of required fields above like mint as the parent won't have a mint - it will replicate certain required fields that will be the same)
18. Parent Name (Cosmic Eggs in our case)
19. Project URL (Cosmiceggs.app)
20. Defined valuation method (tricky since this may be multiple)

De-Listing
1. User pays fee to delist
2. User receives collateral back to origination account.

Usage
1. Value asset - return price using value method, some will be semi-static (only change on epoch) and some will be dynamic (have a dex or exchange related price) - we can charge a fee here. For epoch driven, we need to update the value after epoch changes. @l we may want to put a redemption "hold" until value updated each epoch.
2. View over time - feed data to a chart - to Lirons point, like coin market cap, can create candles or only show 1 data point for each x epochs when looking at large amounts of data.

Additional usecases
1. Token creation
2. Token sales (escrow and conditional distributions)
3. Running nodes

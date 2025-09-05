;; Title: ReputaLink Protocol
;;
;; Summary:
;; A next-generation decentralized social networking protocol that creates 
;; verifiable, stake-backed digital relationships on Bitcoin's infrastructure 
;; through Stacks smart contracts, revolutionizing how social credibility 
;; and reputation are built and maintained.
;;
;; Description:
;; ReputaLink transforms social networking by introducing economic accountability 
;; to digital relationships. Built on Bitcoin's secure foundation via Stacks, 
;; it creates an immutable social graph where users stake STX tokens to establish 
;; credibility, build meaningful connections, and earn reputation through genuine 
;; community engagement. The protocol features stake-weighted influence systems, 
;; peer-to-peer endorsements, content amplification mechanisms, and transparent 
;; reputation scoring - creating a trustworthy social ecosystem where quality 
;; interactions are economically incentivized and manipulation is costly.
;;
;; Key Features:
;; - Economic-backed social identity and reputation system
;; - Stake-to-participate model ensuring genuine user engagement
;; - Transparent on-chain social graph with Bitcoin-level security
;; - Peer endorsement system with economic consequences
;; - Content amplification through community-driven token staking
;; - Cross-platform portable reputation and social identity

;; PROTOCOL CONSTANTS

(define-constant CONTRACT_OWNER tx-sender)

;; Error Codes
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_PROFILE_EXISTS (err u101))
(define-constant ERR_PROFILE_NOT_FOUND (err u102))
(define-constant ERR_INSUFFICIENT_FUNDS (err u103))
(define-constant ERR_INVALID_AMOUNT (err u104))
(define-constant ERR_ALREADY_FOLLOWING (err u105))
(define-constant ERR_NOT_FOLLOWING (err u106))
(define-constant ERR_SELF_ACTION (err u107))
(define-constant ERR_ALREADY_ENDORSED (err u108))
(define-constant ERR_POST_NOT_FOUND (err u109))

;; Minimum Stake Requirements (in microSTX)
(define-constant MIN_PROFILE_STAKE u1000000)    ;; 1 STX - Identity verification
(define-constant MIN_CONTENT_BOOST u100000)     ;; 0.1 STX - Content amplification
(define-constant MIN_ENDORSEMENT u500000)       ;; 0.5 STX - Peer validation

;; STATE VARIABLES

(define-data-var next-profile-id uint u1)
(define-data-var next-post-id uint u1)
(define-data-var protocol-fee-rate uint u100) ;; 1% = 100 basis points

;; DATA STRUCTURES

;; User Profile Registry
(define-map profiles
  { profile-id: uint }
  {
    owner: principal,
    username: (string-ascii 50),
    bio: (string-utf8 280),
    avatar-url: (string-ascii 200),
    created-at: uint,
    staked-amount: uint,
    reputation-score: uint,
    follower-count: uint,
    following-count: uint,
    post-count: uint,
    total-endorsements: uint,
    is-active: bool
  }
)

;; Identity Resolution Maps
(define-map username-to-profile (string-ascii 50) uint)
(define-map principal-to-profile principal uint)

;; Social Graph Connections
(define-map following
  { follower: uint, following: uint }
  { followed-at: uint, is-active: bool }
)

;; Content Publication System
(define-map posts
  { post-id: uint }
  {
    author: uint,
    content: (string-utf8 500),
    created-at: uint,
    boosted-amount: uint,
    endorsement-count: uint,
    is-active: bool
  }
)

;; Endorsement Systems
(define-map post-endorsements
  { post-id: uint, endorser: uint }
  { endorsed-at: uint, stake-amount: uint }
)

(define-map profile-endorsements
  { endorser: uint, endorsed: uint }
  { endorsed-at: uint, stake-amount: uint, message: (string-utf8 140) }
)

;; Economic Systems
(define-map profile-stakes
  { profile-id: uint, staker: principal }
  { amount: uint, staked-at: uint }
)

(define-map post-boosts
  { post-id: uint, booster: principal }
  { amount: uint, boosted-at: uint }
)

;; READ-ONLY FUNCTIONS

;; Profile Retrieval Functions
(define-read-only (get-profile (profile-id uint))
  (map-get? profiles { profile-id: profile-id })
)

(define-read-only (get-profile-by-username (username (string-ascii 50)))
  (match (map-get? username-to-profile username)
    profile-id (get-profile profile-id)
    none
  )
)

(define-read-only (get-profile-by-principal (user principal))
  (match (map-get? principal-to-profile user)
    profile-id (get-profile profile-id)
    none
  )
)

;; Utility Functions
(define-read-only (is-username-available (username (string-ascii 50)))
  (is-none (map-get? username-to-profile username))
)

(define-read-only (is-following (follower-id uint) (following-id uint))
  (match (map-get? following { follower: follower-id, following: following-id })
    follow-data (get is-active follow-data)
    false
  )
)

(define-read-only (get-post (post-id uint))
  (map-get? posts { post-id: post-id })
)

;; Protocol State Functions
(define-read-only (get-next-profile-id)
  (var-get next-profile-id)
)

(define-read-only (get-next-post-id)
  (var-get next-post-id)
)

;; Reputation Calculation
(define-read-only (calculate-reputation-score (profile-id uint))
  (match (get-profile profile-id)
    profile-data
    (let
      (
        (base-score (get staked-amount profile-data))
        (social-bonus (* (get follower-count profile-data) u1000))
        (trust-bonus (* (get total-endorsements profile-data) u2000))
        (content-bonus (* (get post-count profile-data) u500))
      )
      (+ base-score (+ social-bonus (+ trust-bonus content-bonus)))
    )
    u0
  )
)

;; PUBLIC FUNCTIONS - PROFILE MANAGEMENT

;; Create Verified Profile
(define-public (create-profile 
  (username (string-ascii 50))
  (bio (string-utf8 280))
  (avatar-url (string-ascii 200))
)
  (let
    (
      (profile-id (var-get next-profile-id))
      (current-block stacks-block-height)
    )
    ;; Validation Checks
    (asserts! (is-none (map-get? principal-to-profile tx-sender)) ERR_PROFILE_EXISTS)
    (asserts! (is-username-available username) ERR_PROFILE_EXISTS)
    (asserts! (>= (stx-get-balance tx-sender) MIN_PROFILE_STAKE) ERR_INSUFFICIENT_FUNDS)
    
    ;; Lock Initial Stake
    (try! (stx-transfer? MIN_PROFILE_STAKE tx-sender (as-contract tx-sender)))
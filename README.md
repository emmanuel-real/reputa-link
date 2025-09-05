# ReputaLink Protocol

[![Stacks](https://img.shields.io/badge/Built%20on-Stacks-5546FF?style=flat-square&logo=stacks)](https://www.stacks.co/)
[![Bitcoin](https://img.shields.io/badge/Secured%20by-Bitcoin-F7931A?style=flat-square&logo=bitcoin)](https://bitcoin.org/)
[![Clarity](https://img.shields.io/badge/Smart%20Contract-Clarity-8A2BE2?style=flat-square)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

> A next-generation decentralized social networking protocol that creates verifiable, stake-backed digital relationships on Bitcoin's infrastructure through Stacks smart contracts.

## 🌟 Overview

ReputaLink transforms social networking by introducing economic accountability to digital relationships. Built on Bitcoin's secure foundation via Stacks, it creates an immutable social graph where users stake STX tokens to establish credibility, build meaningful connections, and earn reputation through genuine community engagement.

### Key Innovation

Unlike traditional social networks where influence can be artificially inflated, ReputaLink requires economic skin-in-the-game for all social actions, creating a trustworthy ecosystem where quality interactions are incentivized and manipulation is economically prohibitive.

## 🚀 Key Features

### 🔐 Economic-Backed Identity System

- **Stake-to-Participate**: Users must stake STX tokens to create profiles and participate
- **Verifiable Identity**: On-chain identity verification through economic commitment
- **Reputation Scoring**: Transparent, algorithmic reputation calculation based on stakes and social metrics

### 🌐 Decentralized Social Graph

- **Bitcoin-Level Security**: Social relationships secured by Bitcoin's proof-of-work
- **Immutable Connections**: Follow relationships permanently recorded on-chain
- **Cross-Platform Portability**: Reputation and social graph owned by users, not platforms

### 💎 Stake-Weighted Influence

- **Credibility Tokens**: Higher stakes = greater influence in the network
- **Anti-Sybil Protection**: Economic barriers prevent fake account proliferation
- **Organic Growth**: Genuine engagement rewarded with increased reputation

### 🤝 Peer Endorsement System

- **Economic Endorsements**: Users stake tokens to vouch for others
- **Trust Networks**: Build credible networks through mutual endorsements
- **Accountability**: Endorsements carry economic risk, ensuring careful consideration

### 📈 Content Amplification

- **Boost Mechanism**: Stake tokens to amplify quality content
- **Community Curation**: Economic incentives for promoting valuable content
- **Creator Rewards**: Content creators benefit from community investment

## 🏗 Architecture

### Smart Contract Structure

```
ReputaLink Protocol
├── Profile Management
│   ├── Identity Creation & Verification
│   ├── Reputation Scoring
│   └── Stake Management
├── Social Graph
│   ├── Follow/Unfollow System
│   ├── Connection Metrics
│   └── Relationship Mapping
├── Content System
│   ├── Post Creation
│   ├── Content Boosting
│   └── Engagement Tracking
├── Endorsement Engine
│   ├── Profile Endorsements
│   ├── Post Endorsements
│   └── Trust Network Building
└── Economic Layer
    ├── Staking Mechanisms
    ├── Token Economics
    └── Fee Management
```

### Core Data Structures

| Structure | Purpose | Key Features |
|-----------|---------|--------------|
| **Profiles** | User identity & reputation | Username, bio, reputation score, stakes |
| **Following** | Social connections | Follower/following relationships |
| **Posts** | Content publication | Author, content, boosts, endorsements |
| **Endorsements** | Trust validation | Peer vouching with economic backing |
| **Stakes** | Economic participation | Token commitments for various actions |

## 💰 Token Economics

### Stake Requirements

| Action | Minimum Stake | Purpose |
|--------|---------------|---------|
| **Profile Creation** | 1.0 STX | Identity verification & anti-sybil |
| **Content Boost** | 0.1 STX | Content amplification |
| **Endorsement** | 0.5 STX | Peer validation & trust building |
| **Reputation Staking** | 0.1+ STX | Enhanced influence & credibility |

### Reputation Scoring Algorithm

```clarity
reputation_score = base_stake + social_bonus + trust_bonus + content_bonus

Where:
- base_stake = Total STX staked by user
- social_bonus = follower_count × 1,000
- trust_bonus = total_endorsements × 2,000  
- content_bonus = post_count × 500
```

## 🔧 Installation & Setup

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks development environment
- [Node.js](https://nodejs.org/) (v16+ recommended)
- [Git](https://git-scm.com/)

### Local Development

1. **Clone the repository**

   ```bash
   git clone https://github.com/emmanuel-real/reputa-link.git
   cd reputa-link
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Run contract checks**

   ```bash
   clarinet check
   ```

4. **Run tests**

   ```bash
   npm test
   ```

5. **Start local development environment**

   ```bash
   clarinet integrate
   ```

## 📖 API Reference

### Profile Management

#### `create-profile`

Create a new verified profile with economic stake.

```clarity
(create-profile 
  (username (string-ascii 50))
  (bio (string-utf8 280))
  (avatar-url (string-ascii 200))
)
```

**Parameters:**

- `username`: Unique identifier (50 chars max)
- `bio`: Profile description (280 chars max)
- `avatar-url`: Profile image URL (200 chars max)

**Returns:** `(ok profile-id)` or error

**Stake Required:** 1.0 STX

#### `update-profile`

Update profile information (bio and avatar).

```clarity
(update-profile 
  (bio (string-utf8 280))
  (avatar-url (string-ascii 200))
)
```

#### `stake-for-reputation`

Increase reputation by staking additional tokens.

```clarity
(stake-for-reputation (amount uint))
```

**Parameters:**

- `amount`: STX amount to stake (minimum 0.1 STX)

### Social Connections

#### `follow-user`

Establish a follow relationship with another user.

```clarity
(follow-user (following-id uint))
```

**Parameters:**

- `following-id`: Profile ID to follow

#### `unfollow-user`

Remove a follow relationship.

```clarity
(unfollow-user (following-id uint))
```

### Content Management

#### `create-post`

Publish content to the network.

```clarity
(create-post (content (string-utf8 500)))
```

**Parameters:**

- `content`: Post content (500 chars max)

#### `boost-post`

Amplify content by staking tokens.

```clarity
(boost-post (post-id uint) (amount uint))
```

**Parameters:**

- `post-id`: Target post ID
- `amount`: STX amount to boost (minimum 0.1 STX)

### Endorsement System

#### `endorse-profile`

Vouch for another user with economic backing.

```clarity
(endorse-profile 
  (endorsed-id uint)
  (stake-amount uint)
  (message (string-utf8 140))
)
```

**Parameters:**

- `endorsed-id`: Profile ID to endorse
- `stake-amount`: STX amount to stake (minimum 0.5 STX)
- `message`: Endorsement message (140 chars max)

#### `endorse-post`

Validate content quality with token stake.

```clarity
(endorse-post (post-id uint) (stake-amount uint))
```

### Query Functions

#### Profile Queries

```clarity
(get-profile (profile-id uint))
(get-profile-by-username (username (string-ascii 50)))
(get-profile-by-principal (user principal))
(is-username-available (username (string-ascii 50)))
```

#### Social Queries

```clarity
(is-following (follower-id uint) (following-id uint))
```

#### Content Queries

```clarity
(get-post (post-id uint))
```

#### Reputation Queries

```clarity
(calculate-reputation-score (profile-id uint))
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test file
npx vitest tests/reputa-link.test.ts
```

### Test Coverage

Our test suite covers:

- ✅ Profile creation and management
- ✅ Social connection functionality
- ✅ Content publication and boosting
- ✅ Endorsement mechanisms
- ✅ Token economics and staking
- ✅ Error handling and edge cases
- ✅ Access control and security

## 🛡 Security Considerations

### Economic Security

- **Stake Requirements**: All actions require economic commitment
- **Anti-Sybil Protection**: Token costs prevent fake account creation
- **Slashing Mechanisms**: Bad actors risk losing staked tokens

### Access Control

- **Owner Functions**: Critical functions restricted to contract owner
- **Profile Ownership**: Users can only modify their own profiles
- **Self-Action Prevention**: Users cannot follow/endorse themselves

### Input Validation

- **String Length Limits**: All text inputs have maximum length constraints
- **Numeric Bounds**: Amount validations prevent overflow/underflow
- **Existence Checks**: Operations verify referenced entities exist

## 🗺 Roadmap

### Phase 1: Core Protocol ✅

- [x] Basic profile management
- [x] Social graph functionality
- [x] Content publication system
- [x] Endorsement mechanisms

### Phase 2: Advanced Features 🔄

- [ ] Governance token integration
- [ ] Advanced reputation algorithms
- [ ] Cross-chain bridge support
- [ ] Mobile SDK development

### Phase 3: Ecosystem Growth 📅

- [ ] Developer API and SDKs
- [ ] Third-party integrations
- [ ] Community governance
- [ ] Tokenomics optimization

## 🤝 Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and add tests
4. Ensure tests pass: `npm test`
5. Commit changes: `git commit -m 'Add amazing feature'`
6. Push to branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Stacks Foundation** for the robust blockchain infrastructure
- **Bitcoin** for providing the security foundation
- **Clarity Language** for safe smart contract development
- **Community Contributors** for their valuable feedback and contributions

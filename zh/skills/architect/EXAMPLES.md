# 架构示例 - 好的/坏的架构对比

本文档提供具体的架构设计示例，通过对比好的架构和坏的架构，帮助理解架构设计原则。

---

## 好的架构示例

### 示例1: 清晰的模块边界（用户认证系统）

**场景**：设计一个用户认证系统

**架构设计**：
```
┌─────────────────────────────────────────┐
│  Presentation Layer (Controller)       │
│  - AuthController                       │
│  - 处理HTTP请求/响应                     │
└────────────┬────────────────────────────┘
             │ 依赖抽象接口
             ▼
┌─────────────────────────────────────────┐
│  Application Layer (Use Cases)         │
│  - LoginUseCase                         │
│  - RegisterUseCase                      │
│  - 业务流程编排                          │
└────────────┬────────────────────────────┘
             │ 依赖抽象接口
             ▼
┌─────────────────────────────────────────┐
│  Domain Layer (Business Logic)         │
│  - User Entity                          │
│  - IUserRepository (接口)               │
│  - 业务规则和验证                        │
└────────────┬────────────────────────────┘
             │ 实现接口
             ▼
┌─────────────────────────────────────────┐
│  Infrastructure Layer                   │
│  - UserRepositoryImpl                   │
│  - Database/Redis/Email Service         │
└─────────────────────────────────────────┘
```

**优点**：
- ✅ 依赖方向单向（从外向内）
- ✅ 核心业务逻辑不依赖基础设施
- ✅ 易于替换实现（数据库切换无需改业务逻辑）

**数据流示例**：
```
用户登录请求
  → Controller接收
  → LoginUseCase编排流程
  → User.validatePassword()验证
  → UserRepository查询数据库
  → 返回JWT Token
```

---

### 示例2: 良好的依赖管理（电商订单系统）

**场景**：订单系统需要处理支付、库存、通知

**架构设计**：
```
┌────────────────────────────────────────────┐
│  OrderService (应用层)                     │
│  - createOrder(orderData)                  │
│  - 依赖接口: IPayment, IInventory, INotify │
└──────────┬─────────────────────────────────┘
           │ 依赖注入
           ▼
┌──────────────────────────────────────────────┐
│  抽象层 (Domain Interfaces)                 │
│  - IPaymentService                           │
│  - IInventoryService                         │
│  - INotificationService                      │
└──────────┬───────────────────────────────────┘
           │ 实现
           ▼
┌──────────────────────────────────────────────┐
│  实现层 (Infrastructure)                    │
│  - StripePaymentService implements IPayment  │
│  - RedisInventoryService implements IInv...  │
│  - EmailNotificationService implements IN... │
└──────────────────────────────────────────────┘
```

**优点**：
- ✅ 遵守依赖反转原则（DIP）
- ✅ 高层模块不依赖低层实现
- ✅ 易于切换实现（Stripe → PayPal）

**事件流示例**：
```
创建订单事件流：
1. OrderService.createOrder()
2. → IInventoryService.reserve()（检查库存）
3. → IPaymentService.charge()（扣款）
4. → OrderRepository.save()（保存订单）
5. → INotificationService.send()（发送通知）
6. → 事务提交/回滚处理
```

---

### 示例3: 归一化的数据输入层（多渠道聊天系统）

**场景**：支持微信、钉钉、Slack多渠道消息

**架构设计**：
```
┌─────────────────────────────────────────────┐
│  外部输入层 (Adapters)                      │
│  - WeChatAdapter                            │
│  - DingTalkAdapter                          │
│  - SlackAdapter                             │
└──────────┬──────────────────────────────────┘
           │ 转换为统一消息格式
           ▼
┌─────────────────────────────────────────────┐
│  归一化层 (Normalization)                   │
│  - MessageNormalizer                        │
│  - 统一消息模型: UnifiedMessage             │
│    {sender, content, timestamp, channel}    │
└──────────┬──────────────────────────────────┘
           │ 统一处理
           ▼
┌─────────────────────────────────────────────┐
│  业务层 (Business Logic)                    │
│  - MessageHandler                           │
│  - 关键词检测、自动回复、转人工             │
└─────────────────────────────────────────────┘
```

**优点**：
- ✅ 遵守归一化原则（多输入统一抽象）
- ✅ 业务层无需关心渠道差异
- ✅ 新增渠道只需加Adapter，业务层不变
- ✅ 易于维护

---

## 坏的架构示例

### 反例1: 循环依赖（用户和订单模块）

**问题代码**：
```
┌──────────────┐         ┌──────────────┐
│ UserService  │ ───────>│ OrderService │
│              │         │              │
│ getUserOrders() <─────│ getOrderUser()│
│              │         │              │
└──────────────┘         └──────────────┘
      ▲                        │
      └────────循环依赖─────────┘
```

**问题分析**：
- ❌ UserService依赖OrderService
- ❌ OrderService依赖UserService
- ❌ 修改一个模块影响另一个
- ❌ 难以确定初始化顺序

**修复方案**：引入中间层
```
┌──────────────┐         ┌──────────────┐
│ UserService  │         │ OrderService │
└──────┬───────┘         └──────┬───────┘
       │                        │
       │  依赖接口               │
       ▼                        ▼
┌─────────────────────────────────────┐
│  Domain Layer (Interfaces)          │
│  - IUserRepository                  │
│  - IOrderRepository                 │
└─────────────────────────────────────┘
       ▲                        ▲
       │                        │
┌──────┴───────┐         ┌──────┴───────┐
│UserRepoImpl  │         │OrderRepoImpl │
└──────────────┘         └──────────────┘
```

---

### 反例2: 过度耦合（直接依赖具体实现）

**问题架构**：

| 组件 | 依赖方式 | 问题 |
|------|----------|------|
| OrderService | 直接创建MySQLDatabase | 无法切换数据库 |
| OrderService | 直接创建StripePayment | 无法切换支付渠道 |
| OrderService | 直接创建SendGridEmail | 无法切换通知服务 |

**问题分析**：
- ❌ 无法切换数据库（MySQL → PostgreSQL）
- ❌ 无法切换支付渠道（Stripe → PayPal）
- ❌ 违反开闭原则（OCP）

**修复方案**：依赖注入

| 组件 | 依赖方式 | 优点 |
|------|----------|------|
| OrderService | 依赖IDatabase接口 | 可切换任意数据库实现 |
| OrderService | 依赖IPaymentService接口 | 可切换任意支付实现 |
| OrderService | 依赖INotificationService接口 | 可切换任意通知实现 |

**接口契约**：

| 接口 | 方法 | 说明 |
|------|------|------|
| IDatabase | save(data) | 保存数据 |
| IPaymentService | charge(amount) | 扣款 |
| INotificationService | send(recipient, template) | 发送通知 |

---

### 反例3: 违反YAGNI原则（过度设计）

**问题代码**：
```
# 当前需求：实现用户注册功能

❌ 坏的设计（过度设计）：
┌─────────────────────────────────────────┐
│  UserRegistrationAbstractFactoryBuilder │  ← 不需要
├─────────────────────────────────────────┤
│  UserRegistrationStrategy (接口)        │  ← 不需要
│  - EmailRegistrationStrategy            │  ← 不需要
│  - PhoneRegistrationStrategy            │  ← 暂无需求
│  - OAuthRegistrationStrategy            │  ← 暂无需求
├─────────────────────────────────────────┤
│  UserRegistrationEventBus               │  ← 不需要
│  UserRegistrationCache                  │  ← 过早优化
│  UserRegistrationCircuitBreaker         │  ← 不需要
└─────────────────────────────────────────┘
```

**问题分析**：
- ❌ 当前只需要邮箱注册，设计了多种策略
- ❌ 引入不必要的复杂性
- ❌ 增加开发时间和维护成本
- ❌ 违反YAGNI（You Aren't Gonna Need It）

**正确方案**：
```
✅ 好的设计（满足当前需求）：
┌─────────────────────────────────────────┐
│  UserService                            │
│  - registerByEmail(email, password)     │
│  - validateEmail()                      │
│  - sendVerificationEmail()              │
└─────────────────────────────────────────┘

未来需要时再扩展：
- 需要手机注册时，再添加registerByPhone()
- 需要OAuth时，再添加registerByOAuth()
- 需要事件总线时，再引入EventBus
```

---

### 反例4: 缺少抽象层（多来源输入未归一化）

**问题架构**：

| 处理方法 | 输入格式 | 问题 |
|----------|----------|------|
| handle_wechat_message | wechat_msg['FromUserName'] | 微信特定格式 |
| handle_slack_message | slack_msg['user']['id'] | Slack特定格式 |
| handle_dingtalk_message | dingtalk_msg['senderId'] | 钉钉特定格式 |

**每个渠道的字段映射**：

| 渠道 | 发送者字段 | 内容字段 |
|------|------------|----------|
| 微信 | FromUserName | Content |
| Slack | user.id | text |
| 钉钉 | senderId | text.content |

**问题分析**：
- ❌ 重复的处理逻辑（每个渠道都要写提取→处理→响应）
- ❌ 新增渠道需要修改业务层
- ❌ 难以维护
- ❌ 违反归一化原则

**修复方案**：见"好的架构示例3"（归一化层 + 统一消息模型）

---

## 架构决策对比表

| 架构特征 | 好的架构 | 坏的架构 |
|---------|---------|---------|
| 依赖方向 | 单向，从外向内 | 循环依赖 |
| 抽象层 | 依赖接口，不依赖实现 | 直接依赖具体实现 |
| 模块边界 | 清晰，职责单一 | 模糊，职责混乱 |
| 扩展性 | 符合OCP，易扩展 | 修改核心代码才能扩展 |
| 归一化 | 多输入统一抽象 | 每种输入单独处理 |
| YAGNI | 只实现当前需求 | 过度设计未来需求 |

---

## 快速检查清单

审查架构设计时，快速检查以下问题：

### ✅ 好的架构应该
- [ ] 依赖方向明确（单向，从外向内）
- [ ] 核心业务逻辑不依赖外部实现
- [ ] 模块边界清晰，职责单一
- [ ] 易于替换实现（数据库、支付、通知等）
- [ ] 多输入源有统一抽象层
- [ ] 只实现当前需求，不过度设计

### ❌ 坏的架构特征
- [ ] 存在循环依赖
- [ ] 直接依赖具体实现（new MySQLDatabase()）
- [ ] 模块职责不清（一个类做太多事）
- [ ] 难以切换实现（切换数据库需改大量代码）
- [ ] 多输入源各自处理（重复逻辑）
- [ ] 过度设计（实现暂无需求的功能）

---

## 参考资料

- 《Clean Architecture》 - Robert C. Martin
- 《Domain-Driven Design》 - Eric Evans
- 《Patterns of Enterprise Application Architecture》 - Martin Fowler

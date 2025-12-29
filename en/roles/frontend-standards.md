# Frontend Development Standards - CODING-STANDARDS-FRONTEND

**Version**: 2.0.0
**Scope**: Frontend development positions (Web/Mobile/Desktop applications, technology stack agnostic)
**Last Updated**: 2025-12-25

---

## 🚨 Core Iron Rules (Inherited from common.md)

> **Must follow the four core iron rules from common.md**

```
Iron Rule 1: SPEC is the Only Source of Truth (SSOT)
       - UI implementation must comply with SPEC definitions
       - Interactions, layout, and styles follow SPEC

Iron Rule 2: Smart Reuse and Destroy-Rebuild
       - Existing components completely matched → Direct reuse
       - Partial match → Delete and rebuild, no incremental modifications

Iron Rule 3: Prohibitive Incremental Development
       - Prohibit adding new features to old components
       - Prohibit retaining compatibility code

Iron Rule 4: Context7 Research First
       - Use mature UI libraries and components
       - Prohibit implementing common UI components from scratch
```

---

## 🏗️ Component Design

### Component Responsibilities
- ✅ Single component file < 300 lines
- ✅ Component responsible for only one function or UI fragment
- ✅ Separate container components from presentation components
- ❌ Prohibit "god components" containing multiple unrelated functions

### Component Hierarchy
- ✅ Atomic components: Button, Input, Icon (indivisible)
- ✅ Molecular components: Search box = Input + Button
- ✅ Organizational components: Header = Logo + Navigation + Search
- ✅ Nesting level < 5 layers

### Props/Interface Design
- ✅ Single component Props < 10
- ✅ Required and optional parameters clearly marked
- ✅ Boolean values use is/has/should prefix
- ✅ Event callbacks use on prefix
- ✅ Use type definitions (TypeScript/Flow/PropTypes)
- ❌ Prohibit Props type of any

---

## 📊 State Management

### State Principles
- ✅ Each data has only one single source of truth
- ✅ Store only necessary state, don't store what can be computed
- ✅ Promote shared state to common parent component
- ✅ Use immutable updates (don't directly modify state)
- ❌ Prohibit maintaining the same data in multiple places

### Data Flow
- ✅ Data flows from parent component to child component
- ✅ Events flow from child component to parent component
- ✅ State changes trigger UI updates
- ❌ Avoid bidirectional binding complexity (unless framework-enforced)

---

## 🎨 HTML/CSS Standards

### Semantic HTML
- ✅ Use semantic tags (header, nav, main, article, footer)
- ✅ Form fields must have labels
- ✅ Images must have alt attributes
- ✅ Pass W3C validation
- ❌ Avoid overuse of div and span

### CSS Naming
- ✅ Use consistent naming methods (BEM, CSS Modules, CSS-in-JS)
- ✅ Style scope isolation, avoid global pollution
- ✅ Class names semantic, express purpose not style
- ❌ Prohibit inline styles (unless dynamic calculation)

### Responsive Design
- ✅ Mobile-first design
- ✅ Use relative units (rem, em, %, vh/vw)
- ✅ Use media queries for different screens
- ✅ Validate common device sizes (mobile, tablet, desktop)
- ✅ Touch targets ≥ 44x44px

---

## ⚡ Performance Optimization

### Rendering Optimization
- ✅ Avoid unnecessary re-renders (use caching mechanisms)
- ✅ List rendering must have unique keys
- ✅ Long lists (>100 items) use virtualization
- ✅ Large datasets paginate loading
- ❌ Prohibit defining components in render functions

### Code Splitting
- ✅ Route-level code splitting
- ✅ Large component lazy loading
- ✅ Third-party libraries on-demand import
- ✅ Initial load size < 200KB (gzip)

### Resource Optimization
- ✅ Image lazy loading
- ✅ Use modern image formats (WebP, AVIF)
- ✅ Responsive images (srcset)
- ✅ Compress and optimize resources
- ✅ Critical resource preloading (preload)

---

## ♿ Accessibility

### WCAG Compliance
- ✅ Keyboard accessible (Tab navigation)
- ✅ Screen reader friendly (ARIA labels)
- ✅ Color contrast ≥ 4.5:1 (normal text)
- ✅ Focus visible (focus states)
- ✅ Clear form error messages

### Common Requirements
- ✅ Interactive elements have focus states
- ✅ Buttons and links have clear text
- ✅ Dynamic content updates notify screen readers
- ❌ Prohibit distinguishing states only by color

---

## 🔒 Frontend Security

### XSS Protection
- ✅ Use framework's auto-escaping
- ❌ Prohibit using dangerous HTML injection APIs (like dangerouslySetInnerHTML)
- ✅ User input must be validated and sanitized
- ✅ Set CSP (Content Security Policy)

### CSRF Protection
- ✅ Use CSRF Token
- ✅ SameSite Cookie
- ✅ Verify request origin

### Sensitive Data
- ❌ Prohibit storing sensitive information in frontend (passwords, complete ID cards)
- ✅ Tokens stored in HttpOnly Cookie or secure storage
- ✅ HTTPS transmission
- ✅ Secondary confirmation for sensitive operations

---

## 📋 Frontend Development Checklist

- [ ] Single component responsibility (< 300 lines)
- [ ] Props type definitions complete
- [ ] State management clear (single data source)
- [ ] Semantic HTML tags
- [ ] CSS style isolation
- [ ] Responsive design
- [ ] Performance optimization (lazy loading, virtualization)
- [ ] Accessibility (keyboard, ARIA, contrast)
- [ ] XSS/CSRF protection

---

---

## 🏛️ Advanced Architectural Patterns (20+ years experience)

### Micro-Frontend Architecture
```
✅ Use cases:
- Large applications with multi-team collaboration
- Modules requiring independent deployment
- Heterogeneous technology stacks (React/Vue/Angular coexistence)

Architecture patterns:
- Module Federation (Webpack 5)
- Single-SPA orchestration
- qiankun sandbox isolation
- Web Components boundaries

Communication mechanisms:
- CustomEvent cross-application communication
- Shared state management (Redux/Zustand Store Slice)
- PostMessage secure channels
```

### Advanced State Management Patterns
```
Atomic state (Jotai/Recoil):
- Bottom-up state atoms
- Derived state auto-computation
- Precise subscriptions, minimal re-renders

Server state (TanStack Query/SWR):
- Request caching and deduplication
- Optimistic updates
- Background refresh
- Offline support

State machines (XState):
- Complex business process modeling
- Clear state transitions
- Visual debugging
```

### Rendering Architecture Selection
```
CSR (Client-Side Rendering):
- Use cases: Interactive-intensive applications (admin dashboards)
- Drawbacks: Slow first screen, poor SEO

SSR (Server-Side Rendering):
- Use cases: Content websites, SEO requirements
- Technology: Next.js/Nuxt.js
- Note: Hydration cost

SSG (Static Site Generation):
- Use cases: Blogs, documentation sites
- Advantages: Best performance

ISR (Incremental Static Regeneration):
- Use cases: E-commerce product pages
- Combines SSG and SSR advantages

Streaming SSR:
- React 18 Suspense
- Progressive rendering
```

---

## 🔧 Essential Techniques for Senior Developers

### Deep Build Optimization Techniques
```
Bundle Analysis:
- webpack-bundle-analyzer
- source-map-explorer
- Dependency size visualization

Tree Shaking Optimization:
- Ensure sideEffects: false
- Avoid re-exports
- Use ESM format libraries

Code Splitting Strategies:
- Route-level splitting (basic)
- Component-level splitting (advanced)
- Data pre-fetching splitting (expert)

Long-term Caching:
- contenthash filenames
- Extract stable dependencies (vendor chunk)
- Runtime separation (runtime chunk)
```

### Deep Runtime Performance Optimization
```
React Optimization:
- React.memo + useMemo + useCallback trio
- State hoisting, avoid lifting
- Context splitting, avoid overall re-rendering
- Use useTransition to delay non-urgent updates

Vue Optimization:
- v-once for static content
- v-memo for conditional caching
- Functional components
- KeepAlive component caching

General Optimization:
- requestIdleCallback idle scheduling
- IntersectionObserver lazy loading
- ResizeObserver layout monitoring
- Virtual scrolling (react-window/vue-virtual-scroller)
```

### Debugging and Performance Analysis
```
DevTools Advanced Usage:
- Performance Tab flame chart analysis
- Memory Tab memory leak detection
- Coverage Tab code coverage
- Layers Tab compositing layer analysis

React DevTools:
- Profiler component rendering analysis
- Highlight Updates re-render visualization
- Components tree state inspection

Performance Metrics Monitoring:
- Core Web Vitals (LCP/FID/CLS)
- TTFB/FCP/TTI
- Lighthouse CI integration
```

### Complex Form Handling
```
Form Library Selection:
- React Hook Form (performance-first)
- Formik (feature-complete)
- VeeValidate (Vue ecosystem)

Advanced Patterns:
- Dynamic forms (JSON Schema driven)
- Form wizards (multi-step)
- Form联动 (conditional fields)
- Async validation (debounce)

Performance Points:
- Uncontrolled components (reduce re-renders)
- Field-level validation (partial updates)
- Form state isolation
```

---

## 🚨 Common Pitfalls for Senior Developers

### Architecture Pitfalls
```
❌ Over-abstraction:
- Creating overly generic components for "reuse"
- Configuration options more than code
- Correct approach: Start specific, then abstract, Rule of Three

❌ Global State Overuse:
- Put all state in global Store
- Causes severe component coupling
- Correct approach: State proximity principle, can local don't global

❌ Micro-frontend Abuse:
- Forcing micro-frontends on small projects
- Adds complexity without actual benefits
- Correct approach: Evaluate team size and project complexity
```

### Performance Pitfalls
```
❌ useMemo/useCallback Abuse:
- Adding cache everywhere
- Actually increases memory overhead
- Correct approach: Optimize after profiling, don't optimize blindly

❌ Over-component Splitting:
- One component per DOM element
- Props drilling hell
- Correct approach: Reasonable granularity, components have clear responsibilities

❌ Infinite Image Loading:
- No concurrent request limits
- Network blocking
- Correct approach: Request queues, priority scheduling
```

---

## 📊 Performance Monitoring Metrics

| Metric | Target Value | Alert Threshold | Measurement Method |
|--------|-------------|----------------|-------------------|
| LCP | < 2.5s | > 4s | Lighthouse/RUM |
| FID | < 100ms | > 300ms | Lighthouse/RUM |
| CLS | < 0.1 | > 0.25 | Lighthouse/RUM |
| TTI | < 3.8s | > 7.3s | Lighthouse |
| FCP | < 1.8s | > 3s | Lighthouse |
| Bundle Size (gzip) | < 200KB | > 500KB | Bundle Analyzer |
| First screen render | < 1.5s | > 3s | Performance API |
| Memory usage | < 100MB | > 300MB | Memory Tab |
| Component re-renders | < 3 times/interaction | > 10 times | React Profiler |

---

## 📋 Frontend Development Checklist (Complete)

### Basic Check
- [ ] Single component responsibility (< 300 lines)
- [ ] Props type definitions complete
- [ ] State management clear (single data source)
- [ ] Semantic HTML tags
- [ ] CSS style isolation
- [ ] Responsive design

### Performance Check
- [ ] Core Web Vitals meet standards
- [ ] Bundle Size < 200KB (gzip)
- [ ] Route-level code splitting
- [ ] Image lazy loading and modern formats
- [ ] Long list virtualization
- [ ] No memory leaks

### Security Check
- [ ] XSS/CSRF protection
- [ ] No sensitive data storage in frontend
- [ ] CSP policy configured
- [ ] HTTPS enforcement

---

**Frontend Development Principles Summary**:
Component-based, single responsibility, minimal state, semantic HTML, style isolation, responsive design, performance-first, accessibility, security protection

# 🚀 অটো-আপডেট — এখান থেকে এডিট করলেই লাইভ সাইট আপডেট

এই ফোল্ডার: `~/Documents/Ms video /Gemini`
লাইভ সাইট: **https://naims-os.vercel.app**

এখানে ৩ ভাবে অটো আপডেট করা যায়। **রুট ২ (GitHub) সবচেয়ে ভালো**, তবে একবার সেটআপ লাগবে।

---

## ⚡ রুট ১ — Vercel CLI + ওয়াচার (সবচেয়ে দ্রুত, GitHub ছাড়াই)

### 🔥 এক কমান্ডে সেটআপ

```bash
cd "/Users/macbookairm2/Documents/Ms video /Gemini"
bash setup-auto-deploy.sh
```

স্ক্রিপ্ট নিজেই করবে: **লগইন → প্রজেক্ট লিংক → টেস্ট ডিপ্লয়**।
শুধু ব্রাউজারে Vercel লগইন করতে হবে আর প্রজেক্ট লিস্ট থেকে **`naims-os`** বাছতে হবে (নতুন প্রজেক্ট নয়!)।

গ্লোবাল ইনস্টল লাগবে না — `npx` নিজেই Vercel CLI নামিয়ে নেয়।
(এই ম্যাকে `npm i -g vercel` করলে `EACCES: permission denied` আসবে — সেটার দরকারই নেই।)

### ম্যানুয়াল ধাপ (চাইলে)

```bash
npx vercel@latest login     # একবার
npx vercel@latest link      # একবার — naims-os বাছুন
bash deploy.sh              # টেস্ট
```

> ⚠️ `vercel link` না করলে CLI **নতুন প্রজেক্ট** বানিয়ে ফেলবে — তখন `naims-os.vercel.app` ডোমেইনে আপডেট যাবে না।

### এখন অটো চালু করুন

```bash
bash start-auto.sh   # ব্যাকগ্রাউন্ডে ওয়াচার চালু
tail -f auto-deploy.out   # লগ দেখতে
```

এরপর **`index.html` সেভ করলেই ৪ সেকেন্ডের মধ্যে নিজে নিজে ডিপ্লয় হবে**।
আমি (AI) এখানে ফাইল এডিট করলেও একইভাবে অটো ডিপ্লয় হবে।

বন্ধ করতে:

```bash
bash stop-auto.sh
```

### 🔑 টোকেন দিয়ে নন-ইন্টার‌্যাক্টিভ (ঐচ্ছিক)

লগইন ছাড়া/স্ক্রিপ্টে চালাতে চাইলে:
Vercel → Account Settings → **Tokens** → Create Token → কপি করে এই ফোল্ডারে `.vercel-token` ফাইলে রাখুন (এক লাইনে)।

```bash
echo "আপনার_টোকেন" > .vercel-token
```

`.vercel-token` git-এ যাবে না (`.gitignore`-এ আছে)।

---

## 🌟 রুট ২ — GitHub + Vercel Git Integration (রেকমেন্ডেড)

একবার সেট করলে **যেকোনো ডিভাইস থেকে `git push` করলেই** Vercel নিজে বিল্ড + ডিপ্লয় করবে — ওয়াচার চালু রাখতে হবে না।

> 🛠️ **প্রথমে git ইনস্টল করতে হবে** (এই ম্যাকে এখনো নেই):
> ```bash
> xcode-select --install
> ```
> পপ-আপে **Install** চাপুন, শেষ হলে `git --version` দিয়ে দেখুন।

### একবারের সেটআপ

```bash
cd "/Users/macbookairm2/Documents/Ms video /Gemini"

# ১) রিপো তৈরি + প্রথম কমিট
git init -b main
git add -A
git config user.name "Naim"
git config user.email "আপনার@ইমেইল.com"
git commit -m "Naim's OS — Command Center v2"

# ২) GitHub-এ নতুন রিপো বানান (নাম: naims-os), তারপর:
git remote add origin git@github.com:আপনার_ইউজারনেম/naims-os.git
git push -u origin main
```

২) Vercel Dashboard → **naims-os** প্রজেক্ট → **Settings → Git** → **Connect Git Repository** → `naims-os` বাছুন
৩) **Settings → Git → Production Branch** = `main` আছে কি না দেখুন
৪) প্রথমবার Vercel নিজে বিল্ড করবে — এরপর প্রতিবার পুশে অটো ডিপ্লয়

### সেভ করলেই অটো পুশ (ঐচ্ছিক)

```bash
bash git-auto-push.sh    # ৫ সেকেন্ডে অটো কমিট + পুশ (Ctrl+C দিয়ে বন্ধ)
```

---

## 🆚 কোনটা বেছে নেবেন?

| | রুট ১ (CLI ওয়াচার) | রুট ২ (GitHub) |
|---|---|---|
| সেটআপ | লগইন + লিংক | রিপো + Vercel কানেক্ট |
| ল্যাপটপ বন্ধ থাকলে | ❌ চলবে না | ✅ GitHub থেকে ডিপ্লয় হয় |
| হিস্ট্রি/ব্যাকআপ | কমিট নেই | ✅ প্রতিটা ভার্সন GitHub-এ |
| রোলব্যাক | কঠিন | ✅ Vercel-এ এক ক্লিকে |
| স্পিড | সাথে সাথে | ৩০–৬০ সেকেন্ড |

**পরামর্শ:** রুট ২ সেট করুন, দরকার হলে রুট ১-ও চালু রাখুন (দুটো একসাথে সমস্যা নেই, শেষটা জেতে)।

---

## 📁 ফাইলগুলো

| ফাইল | কাজ |
|---|---|
| `setup-auto-deploy.sh` | একবারের সেটআপ: লগইন + লিংক + টেস্ট ডিপ্লয় |
| `deploy.sh` | এক কমান্ডে প্রোডাকশন ডিপ্লয় (`DRY_RUN=1` দিয়ে টেস্ট) |
| `watch-deploy.sh` | `index.html` বদলালে অটো ডিপ্লয় (ফোরগ্রাউন্ড) |
| `start-auto.sh` | ওয়াচার ব্যাকগ্রাউন্ডে চালু |
| `stop-auto.sh` | ওয়াচার বন্ধ |
| `git-auto-push.sh` | সেভ করলেই অটো git কমিট + পুশ |
| `deploy.log` | প্রতিটা ডিপ্লয়ের লগ |
| `auto-deploy.out` | ওয়াচারের লগ |

## 🛠️ সমস্যা হলে

- **`Error: No existing credentials found`** → `vercel login` করুন
- **ডিপ্লয় হয়েছে কিন্তু সাইট পুরনো** → `vercel link` ঠিক আছে কি না দেখুন; `naims-os` প্রজেক্টেই ডিপ্লয় হচ্ছে কি না Vercel ড্যাশবোর্ডে দেখুন
- **ওয়াচার চলছে না** → `tail -n 50 auto-deploy.out`
- **একই সাথে অনেক ডিপ্লয়** → `vercel.json` নেই, স্ট্যাটিক সাইট; সমস্যা নেই, Vercel শেষটাই রাখে

> স্ট্যাটিক সাইট — কোনো বিল্ড স্টেপ নেই। শুধু `index.html` আপডেট হলেই হয়।

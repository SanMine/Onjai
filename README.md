# Oonjai (อุ่นใจ — “Warm Heart”)

A **Flutter + Firebase health management application** inspired by the principles of **Thai traditional medicine**, focusing on balancing the **four elements** — Earth, Water, Wind, and Fire.
Developed as a **volunteer project** to support the **School of Applied Medicine** at Mae Fah Luang University.

---

## 🌟 Features

* 🔑 **Authentication**
  Secure login, signup, and password reset with Firebase Authentication.

* 📅 **Personalized Health Guidance**
  User’s date of birth determines their **day of week → element mapping** for tailored recommendations.

* 🖼️ **Dynamic Content from Firebase**
  Posters and backgrounds for Dashboard, Traveling, and Self-care sections.

* 🍲 **Eating Recommendations**

  * Categorized foods (Great / Avoid / Suggestion)
  * Favorite system to save user-preferred foods

* ✈️ **Traveling Insights**

  * Element-specific travel poster & symptom text
  * Physical therapy routines with posters, descriptions, and linked medicines

* 💊 **Therapy Details**

  * Exercises with visuals and guidance
  * Recommended medicines with images

* 👤 **User Profile**
  Profile photo upload, personal details, date of birth, and element type.

* ⚙️ **Admin-lite CMS**
  Restricted admin interface to upload posters, foods, therapy, and medicine content.

* 🌏 **Internationalization**
  Multi-language support (English + Thai).

---

## 🏗️ Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend & Database:** Firebase (Auth, Firestore, Storage)

## 📲 App Workflow

1. **Login / Sign Up / Forgot Password**
2. **First-time User Popup** → Collect Name & Date of Birth
3. **Dashboard** → Shows element-based poster & 3 main functions:

   * Eating
   * Travelin
   * Self-care
4. **Eating Section** → Food recommendations (Great, Avoid, Suggestion, Favorites)
5. **Traveling Section** → Posters, Symptom guidance, Therapy routines + medicines
6. **Self-care Section** → Element-specific poster
7. **Profile** → User info, profile photo, logout


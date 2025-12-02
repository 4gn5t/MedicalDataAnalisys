import streamlit as st
import pandas as pd
from services.api_client import api_client
from components.tables import render_results_table

st.set_page_config(page_title="Batch Analysis", page_icon="📁", layout="wide")

st.title("📁 Масовий аналіз пацієнтів")
st.markdown("---")

st.markdown("""
### Інструкція:
1. Завантажте CSV файл з даними пацієнтів
2. Переконайтеся, що файл містить усі необхідні колонки
3. Натисніть "Аналізувати всіх пацієнтів"
""")

# Завантаження файлу
uploaded_file = st.file_uploader("Виберіть CSV файл", type=['csv'])

if uploaded_file is not None:
    try:
        df = pd.read_csv(uploaded_file)
        st.success(f"✅ Завантажено {len(df)} записів")

        st.dataframe(df.head(10), use_container_width=True)

        if st.button("🔍 Аналізувати всіх пацієнтів", type="primary"):
            with st.spinner(f"Обробка {len(df)} пацієнтів..."):
                results = api_client.predict_batch(df)

            st.success("✅ Аналіз завершено!")

            # Відображення результатів
            render_results_table(results)

            # Експорт результатів
            results_df = pd.DataFrame(results)
            csv = results_df.to_csv(index=False)

            st.download_button(
                label="📥 Завантажити результати (CSV)",
                data=csv,
                file_name="analysis_results.csv",
                mime="text/csv"
            )

    except Exception as e:
        st.error(f"❌ Помилка обробки файлу: {str(e)}")
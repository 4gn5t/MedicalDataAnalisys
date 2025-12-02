import streamlit as st
from services.api_client import api_client
from components.forms import render_patient_form
from components.visualizations import render_gauge_chart, render_radar_chart, render_status_card

st.set_page_config(page_title="Single Analysis", page_icon="📊", layout="wide")

st.title("📊 Аналіз одного пацієнта")
st.markdown("---")

# Форма введення даних
patient_data = render_patient_form()

# Кнопка аналізу
if st.button("🔍 Провести аналіз", type="primary", use_container_width=True):
    with st.spinner("Аналізуємо дані..."):
        result = api_client.predict_single(patient_data)

    if 'error' in result:
        st.error(f"❌ Помилка: {result['error']}")
    else:
        st.success("✅ Аналіз завершено!")

        # Відображення результатів
        col1, col2 = st.columns(2)

        with col1:
            render_status_card(result)
            render_gauge_chart(result['risk_probability'], "Ризик розвитку захворювань")

        with col2:
            render_radar_chart(patient_data)

        # Детальна інформація
        with st.expander("📋 Детальна інформація"):
            st.json(result)
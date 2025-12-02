import streamlit as st
from typing import Dict


def render_patient_form() -> Dict:
    """Форма для введення даних пацієнта"""
    st.subheader("📝 Введіть дані пацієнта")

    col1, col2 = st.columns(2)

    with col1:
        age = st.number_input("Вік", min_value=1, max_value=120, value=35)
        gender = st.selectbox("Стать", ["Male", "Female"])

        st.markdown("### Гормони щитовидної залози")
        tsh_level = st.number_input("TSH (мкМО/мл)", min_value=0.0, max_value=100.0, value=2.5, step=0.1)
        t3_level = st.number_input("T3 (нмоль/л)", min_value=0.0, max_value=10.0, value=2.0, step=0.1)
        t4_level = st.number_input("T4 (мкг/дл)", min_value=0.0, max_value=25.0, value=8.0, step=0.1)

    with col2:
        st.markdown("### Інші показники")
        insulin = st.number_input("Інсулін (мкМО/мл)", min_value=0.0, max_value=300.0, value=10.0, step=0.1)

        with st.expander("Додаткові показники (опціонально)"):
            hemoglobin = st.number_input("Гемоглобін (г/л)", min_value=0.0, max_value=200.0, value=140.0, step=1.0)
            wbc = st.number_input("Лейкоцити (10^9/л)", min_value=0.0, max_value=50.0, value=7.5, step=0.1)
            rbc = st.number_input("Еритроцити (10^12/л)", min_value=0.0, max_value=10.0, value=5.0, step=0.1)
            platelets = st.number_input("Тромбоцити (10^9/л)", min_value=0.0, max_value=1000.0, value=250.0, step=1.0)

    patient_data = {
        "age": age,
        "gender": gender,
        "tsh_level": tsh_level,
        "t3_level": t3_level,
        "t4_level": t4_level,
        "insulin": insulin,
        "hemoglobin": hemoglobin,
        "wbc": wbc,
        "rbc": rbc,
        "platelets": platelets
    }

    return patient_data
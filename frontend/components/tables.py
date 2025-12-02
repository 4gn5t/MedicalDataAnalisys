import streamlit as st
import pandas as pd
from config import config


def render_reference_table():
    """Таблиця референтних норм"""
    st.subheader("📋 Референтні норми")

    data = []
    for name, (min_val, max_val, unit) in config.NORMAL_RANGES.items():
        data.append({
            "Показник": name,
            "Мінімум": f"{min_val} {unit}",
            "Максимум": f"{max_val} {unit}"
        })

    df = pd.DataFrame(data)
    st.table(df)


def render_results_table(results: list):
    """Таблиця результатів для batch analysis"""
    if not results:
        st.warning("Немає даних для відображення")
        return

    df_data = []
    for i, result in enumerate(results, 1):
        df_data.append({
            "№": i,
            "Статус": result.get('status', 'N/A'),
            "Ризик (%)": f"{result.get('risk_probability', 0):.2f}",
            "Впевненість (%)": f"{result.get('confidence', 0):.2f}",
            "Аномалії": len(result.get('anomalies', []))
        })

    df = pd.DataFrame(df_data)

    # Кольорове виділення статусів
    def highlight_status(row):
        status = row['Статус']
        color = config.STATUS_COLORS.get(status, '#ffffff')
        return [f'background-color: {color}40'] * len(row)

    styled_df = df.style.apply(highlight_status, axis=1)
    st.dataframe(styled_df, use_container_width=True)

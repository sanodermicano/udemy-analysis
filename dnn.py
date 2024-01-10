import numpy as np
import pandas as pd
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Embedding, Flatten, Input

import warnings
warnings.filterwarnings("ignore")

df = pd.read_excel('Course_info.xlsx')

# Preprocessing
predicted = 'avg_rating'
df = df[df[predicted] > 0]
df = df[df['num_reviews'] >= 10]
df['price'] = df['price'].apply(lambda x: 1 / 5 * round(5 * np.log10(x + 1)))
df['num_lectures'] = df['num_lectures'].apply(lambda x: 1 / 5 * round(5 * np.log10(x + 1)))
df['content_length_min'] = df['content_length_min'].apply(lambda x: 1 / 5 * round(5 * np.log10(x + 1)))
df['published_time'] = df['published_time'].apply(lambda x: str(x)[:4])
df = df[df['published_time'] > '2010']
df['instructor_url'] = df['instructor_url'].apply(lambda x: str(x).replace('/user/', '').replace('/', ''))
for col in ['category', 'subcategory', 'topic', 'language', 'instructor_url']:
    df[col] = df[col].fillna('None')
    encoder = LabelEncoder()
    df[col] = encoder.fit_transform(df[col])

cols2drop = ['id', 'title', 'is_paid', 'headline', 'num_subscribers', 'num_reviews',
             'num_comments', 'course_url', 'instructor_name', 'last_update_date']
df = df.drop(cols2drop, axis=1)

y = df[predicted].values.reshape(-1,)
X = df.drop([predicted], axis=1)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.5, random_state=0)

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train.select_dtypes(include=[np.number]))
X_test_scaled = scaler.transform(X_test.select_dtypes(include=[np.number]))

model = Sequential()
model.add(Input(shape=(X_train_scaled.shape[1],)))
model.add(Dense(64, activation='relu'))
model.add(Dense(32, activation='relu'))
model.add(Dense(1, activation='linear'))

model.compile(optimizer='adam', loss='mean_squared_error')

model.fit(X_train_scaled, y_train, epochs=50, batch_size=32, validation_split=0.2, verbose=0)

y_train_pred = model.predict(X_train_scaled).flatten()
y_test_pred = model.predict(X_test_scaled).flatten()

rmse_train = mean_squared_error(y_train, y_train_pred, squared=False)
rmse_test = mean_squared_error(y_test, y_test_pred, squared=False)
print(f"RMSE score for train: {round(rmse_train, 5)}, and for test: {round(rmse_test, 5)}")

results_df = pd.DataFrame({'Actual Rating': y_test, 'Predicted Rating': y_test_pred})
sample_results = results_df.sample(5)

print("Sample of Actual and Predicted Ratings:")
print(sample_results)

plt.figure(figsize=(10, 6))
plt.scatter(y_train, y_train_pred, alpha=0.25, label='Train', color='blue')
plt.scatter(y_test, y_test_pred, alpha=0.25, label='Test', color='orange')
plt.title('Actual vs. Predicted Ratings')
plt.xlabel('Actual Ratings')
plt.ylabel('Predicted Ratings')
plt.legend()
plt.grid(True)
plt.show()
